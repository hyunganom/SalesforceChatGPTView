import { LightningElement, track } from 'lwc';

export default class GPTChat extends LightningElement {
    @track messages = [];
    @track messageInput = '';
    messageId = 0;

    get messageCssClass() {
        return this.messages.map(message => message.type === 'inbound' ? 'slds-chat-listitem slds-chat-listitem_inbound' : 'slds-chat-listitem slds-chat-listitem_outbound');
    }

    get messageTextCssClass() {
        return this.messages.map(message => message.type === 'inbound' ? 'slds-chat-message__text slds-chat-message__text_inbound' : 'slds-chat-message__text slds-chat-message__text_outbound');
    }

    handleKeyPress(event) {
        if (event.key === 'Enter') {
            this.sendMessage();
        }
    }

    sendMessage() {
        if (this.messageInput) {
            this.messages = [
                ...this.messages,
                {
                    id: ++this.messageId,
                    text: this.messageInput,
                    type: 'outbound' // 사용자가 보낸 메시지
                }
            ];
            this.messageInput = '';
        }
    }
}