import { LightningElement, api, track, wire } from 'lwc';
import fetchFields from '@salesforce/apex/AssignmentCaseController.fetchFields';
import Id from "@salesforce/user/Id";

export default class AssingmentPanel extends LightningElement {

    @api recordId;
    @api objectApiName;
    @api fieldSet;
    nameField = '';
    fieldList = [];

    @track isUser = false;

    connectedCallback() {
        fetchFields({
            recordId : this.recordId,
            objectName : this.objectApiName,
            fieldSetName : this.fieldSet
        }).then(result => {
            if(result) {
                console.log(result);
                if(result.message != undefined) {
                    this.showToast('Error', 'error', result.message);
                    return;
                }
                this.nameField = result.nameField;
                this.fieldList = result.fieldsAPI;
            }
        }).catch(error => {
            if(error && error.body && error.body.message) {
                this.showToast('Error', 'error', error.body.message);
            }
        });
    }

}