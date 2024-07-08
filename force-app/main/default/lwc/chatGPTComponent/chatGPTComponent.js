import { LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getChatMessages from '@salesforce/apex/ChatGPTController.getChatMessages';
import sendToChatGPT from '@salesforce/apex/ChatGPTController.sendToChatGPT';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChatGPTComponent extends LightningElement {
    @track chatMessages = [];
    userInput = '';
    wiredChatMessagesResult; 

    @wire(getChatMessages)
    wiredChatMessages(result) {
        this.wiredChatMessagesResult = result;
        const { data, error } = result;
        if (data) {
            this.chatMessages = data.filter(chat => chat.receive__c || chat.send__c);
            this.scrollToBottom();
        } else if (error) {
            console.error('Error retrieving chat messages', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading chat messages',
                    message: error.body.message,
                    variant: 'error',
                })
            );
        }
    }

    connectedCallback() {
        this.refreshInterval = setInterval(() => {
            refreshApex(this.wiredChatMessagesResult);
        }, 5000);
    }

    disconnectedCallback() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
        }
    }

    handleInputChange(event) {
        this.userInput = event.target.value;
    }

    handleSend() {
        if (this.userInput.trim() !== '') {
            sendToChatGPT({ userInput: this.userInput })
                .then(() => {
                    this.chatMessages = [
                        ...this.chatMessages,
                        { Id: this.chatMessages.length + 1, send__c: this.userInput, receive__c: '' }
                    ];
                    this.userInput = '';
                    this.scrollToBottom();
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Message Sent',
                            message: 'Your message has been sent successfully.',
                            variant: 'success',
                        })
                    );
                    refreshApex(this.wiredChatMessagesResult);
                })
                .catch(error => {
                    console.error('Error sending message', error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error sending message',
                            message: error.body.message,
                            variant: 'error',
                        })
                    );
                });
        }
    }

    renderedCallback() {
        this.scrollToBottom();
    }

    scrollToBottom() {
        const chatContainer = this.template.querySelector('[data-id="chatContainer"]');
        if (chatContainer) {
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }
    }
}