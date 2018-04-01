import { Controller } from 'stimulus'
import * as AppendElement from '../html_elements.js'

const host = window.location.origin;

export default class extends Controller {
  static targets = ['conversation', 'question'];

  initialize() {
    this.addToConversation('Tutor Chatbot', 'Hello Student, my name is Tutor Chatbot! Do you have any questions about the XYZ coursework?');
  }
  
  ask(event) {
    event.preventDefault();

    const question = this.questionTarget.value;
    this.questionTarget.value = '';

    this.addToConversation('Student', question);

    fetch(
      window.location.origin + '/module/CM2303/coursework/12/chatbot/find_answer.json?question=' + question + '&lecturer_id=C1529363',
      { credentials: 'same-origin' }
    ).then((response) => response.json())
     .then((json) => this.addToConversation('Tutor Chatbot', json.answer));
  }

  addToConversation(name, text) {
    AppendElement.b(this.conversationTarget, name + ': ');
    AppendElement.text(this.conversationTarget, text);
    AppendElement.br(this.conversationTarget);
  }
}
