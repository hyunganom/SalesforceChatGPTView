import { LightningElement, wire, api, track } from 'lwc';
import {refreshApex} from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from 'lightning/refresh';
import { NavigationMixin } from 'lightning/navigation';

import Id from "@salesforce/user/Id";

import IMAGE from "@salesforce/resourceUrl/Loopy";

import getList from '@salesforce/apex/AssignmentCaseController.getList';
import searchAssignmentCase from '@salesforce/apex/AssignmentCaseController.searchAssignmentCase';
import deleteAssignmentCase from '@salesforce/apex/AssignmentCaseController.deleteAssignmentCase';
import updateInline from '@salesforce/apex/AssignmentCaseController.updateInline';

const ACTIONS = [{label: 'Delete', name:'delete'}, {label: 'Edit', name: 'edit'}];
const COLS = [
    {label: 'Assignment Case Name', fieldName:'detailurl__c', type:'url', typeAttributes: {label: {fieldName: 'Name'}}},
    {label: 'Case Number', fieldName:'Case__c', type:'text', sortable: "true"},
    {label: 'Manager', fieldName:'AssignmentManager__c', type:'text', sortable: "true"},
    {label: 'Status', fieldName:'StatusAssignment__c', type:'text', sortable: "true"},
    {label: 'Date/Time Opened', fieldName: 'CreatedDate', type: 'date', sortable: "true",
        typeAttributes:{
            year: "numeric",
            month: "numeric",
            day: "numeric",
            hour: '2-digit',  
            minute: '2-digit'}
    }
    // ,{fieldName: "actions", type:'action', typeAttributes: {rowActions:ACTIONS}}
];

export default class AssignmentCaseList extends NavigationMixin(LightningElement) {
    cols = COLS;
    assignmentCaseData;
    wiredAssignmentCaseData;
    baseData;
    optionValue;

    

    loopy = IMAGE;

    @track sortBy;
    @track sortDirection;


    Id = Id; // 또는 @api Id = Id; 로 선언해도 됩니다.

    constructor() {
        super();
        // 여기서 this.Id를 사용할 수 있습니다.
        if(this.Id === '005GC00000kz6VxYAI'){
            this.cols.push({label: 'Actions', type: 'action', typeAttributes: {rowActions: ACTIONS}});
        }
    }

    @track isModalOpen = false;
    @track isUser = false;

    renderedCallback() {
        console.log('Id', this.Id);
        // 컴포넌트가 렌더링된 직후에 Id 값을 확인하여 isUser 설정
        if (this.Id === '005GC00000kz6VxYAI') {
            this.isUser = true;
            console.log('isUser', this.isUser);
        }
    }

    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }

    selectedAssignmentCase;
    saveDraftValues = [];
    
    // let nowUrl = window.location.href;

    // 새 레코드 페이지로 이동
    navigateToNewRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'AssignmentCase__c',
                actionName: 'new'
            }
        });
    }
    
    @wire(getList)
    getCaseList(result) {
        console.log('result', result); 
        this.wiredAssignmentCaseData = result;
        if (result.data) {
            this.assignmentCaseData = result.data.map(row => this.mapCaseObj(row));
            this.baseData = this.assignmentCaseData;
            this.dispatchEvent(new RefreshEvent());
        }
        if (result.error) {
            console.error(result.error); 
        }
        console.log('result.data', result.data);
    }

    mapCaseObj(row) {
        return {
            ...row,
            Name: row.Name,
            AssignmentManager__c: row.AssignmentManager__r.Name,
            Case__c: row.Case__r.CaseNumber,
            detailurl__c: '/' + row.Id,
            StatusAssignment__c: row.StatusAssignment__c
        };
    }

    doSorting(event) {
        let sortByField = event.detail.fieldName;
        this.sortBy = sortByField === 'detailurl__c' ? 'Name' : sortByField;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
        this.sortBy = sortByField;
    }

    // 데이터 정렬
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.assignmentCaseData));
        let keyValue = a => a[fieldname] || '';
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => isReverse * ((keyValue(x) > keyValue(y)) - (keyValue(y) > keyValue(x))));
        this.assignmentCaseData = parseData;
    }

    // 레코드 생성 폼 제출
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    // 행에서 발생한 액션 처리
    handleRowAction(event) {
        if (event.detail.action.label === 'Delete') {
            // 선택한 케이스 삭제
            deleteAssignmentCase({ assignmentCaseId: [event.detail.row.Id] })
                .then(() => refreshApex(this.wiredAssignmentCaseData));
            // 성공 토스트 메시지 표시
            this.showToast('성공', '삭제', 'success');
        }
        if (event.detail.action.label === 'Edit') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.row.Id,
                    objectApiName: 'AssignmentCase__c',
                    actionName: 'edit',
                },
            })
            .then((navigateResult) => {
                console.log('');
                if (navigateResult && navigateResult.type === 'standard__recordPage') {
                    console.log('standard__recordPage');
                    // NavigationMixin의 결과가 record 페이지로 이동하는 것인지 확인
                    return this[NavigationMixin.GenerateUrl]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: event.detail.row.Id,
                            objectApiName: 'AssignmentCase__c',
                            actionName: 'edit',
                        },
                    });
                }
                return null;
            })
            .then((url) => {
                if (url) {
                    window.location.href = url;
                }
            })
            .catch(error => {
                // 오류 처리
                console.error(error);
            });
        }

    }

    // 인라인 업데이트 처리
    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        updateInline({ data: updatedFields })
            .then(() => refreshApex(this.wiredAssignmentCaseData))
            .then(() => {
                this.saveDraftValues = [];
                // 성공 토스트 메시지 표시
                this.showToast('성공', '업데이트됨', 'success');
            })
            .catch(error => {
                // 오류 토스트 메시지 표시
                this.showToast('레코드 업데이트 또는 새로고침 오류', error.body.message, 'error');
            });
    }

    // 선택된 행 수 반환
    selectedCase;
    get countSelectLow() {
        return this.selectedCase ? this.selectedCase.length : 0;
    }

    // 선택된 행 처리
    handleRowSelection(event) {
        this.selectedAssignmentCase = event.detail.selectedRows;
    }

    // 검색 옵션 값 가져오기
    getOption(event) {
        this.optionValue = event.target.value;
    }

    // 검색 처리
    async handleSearch(event) {
        if (event.keyCode === 13) {
            if (this.optionValue === undefined) {
                this.optionValue = 'All';
            }

            // Apex 메서드 호출하여 검색 결과 가져오기
            const searchCases = await searchAssignmentCase({ option: this.optionValue, search: event.target.value });
            this.assignmentCaseData = searchCases.map(row => this.mapCaseObj(row));
            console.log('this.assignmentCaseData', this.assignmentCaseData);
        }
    }

    // 선택된 모든 행 삭제
    selectedDeleteAll() {
        const idli = this.selectedCase.map(row => row.Id);
        deleteAssignmentCase({ assignmentCaseId: idli }).then(() => {
            refreshApex(this.wiredAssignmentCaseData);
        });

        // 선택 해제 및 성공 토스트 메시지 표시
        this.template.querySelector('lightning-datatable').selectedRows = [];
        this.selectedCase = undefined;
        this.showToast('성공', '삭제', 'success');
    }

    // 페이지 리로드
    pageReload() {
        window.location.reload();
    }

    // 토스트 메시지 표시
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
    
    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        console.log(fields);
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        this.isModalOpen = false;
    }

    handleSuccess() {
        refreshApex(this.wiredAssignmentCaseData);
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'INSERT가 완료 되었습니다.',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(toastEvent);

    }
}