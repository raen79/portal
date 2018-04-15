import { Controller } from 'stimulus'

const host = window.location.origin;

export default class extends Controller {
  static targets = ['conversation', 'question'];

  initialize() {
    this.base_url = `${host}/course_modules/${this.course_module_id}/courseworks/${this.coursework_id}/chatbot`;
    this.replaceWithPartial(this.conversationTarget, '/greet');
    this._autoScrollConversation();
  }
  
  ask(event) {
    event.preventDefault();

    const question = this.questionTarget.value;
    this.questionTarget.value = '';

    this.appendPartial(this.conversationTarget, `/new_question?question=${question}`);
    this.appendPartial(
      this.conversationTarget,
      `/find_answer?question=${question}&lecturer_id=${this.lecturer_id}`
    );
  }

  get course_module_id() {
    return this.data.get('course-module-id');
  }

  get coursework_id() {
    return this.data.get('coursework-id');
  }

  get lecturer_id() {
    return this.data.get('lecturer-id');
  }

  async appendPartial(target, url) {
    let response = await fetch(this.base_url + url, { credentials: 'same-origin' });
    let html = await response.text();
    const element = document.createElement('div');

    element.innerHTML = html;
    target.appendChild(element);
  }

  _autoScrollConversation() {
    let scroll = () => this.conversationTarget.scrollTop = this.conversationTarget.scrollHeight;
    let mutationObserver = new MutationObserver(scroll);
    mutationObserver.observe(this.conversationTarget, {childList: true});
  }

  async replaceWithPartial(target, url) {
    let response = await fetch(this.base_url + url, { credentials: 'same-origin' });
    let html = await response.text();
    
    target.innerHTML = html;
  }
}
