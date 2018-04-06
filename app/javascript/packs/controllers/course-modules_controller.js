import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['editError', 'newError', 'updateButton', 'name', 'modal'];

  initialize() {
    const notice = this.data.get("notice");

    M.Modal.init(this.modalTarget);

    this.displayErrorMessage(notice);
    this.initializeEditForms();
    this.displayErroneousNewForm();
  }

  initializeEditForms() {
    this.editErrorTargets.forEach(errorElement => {
      setTimeout(() => this.toggleEditForm(errorElement), 1);
    });
  }

  displayErroneousNewForm() {
    console.log(this.newErrorTargets);
    if (this.newErrorTargets.length > 0) {
      M.Modal.getInstance(this.modalTarget).open();
    }
  }

  toggleEditForm(formElement) {
    const courseModuleId = this.getCourseModuleId(formElement);
    const form = this.getEditForm(courseModuleId);

    form.updateButton.siblings.forEach(element => element.classList.toggle('hide'));
    form.nameField.siblings.forEach(element => element.classList.toggle('hide'));
  }

  hideEditForm(event) {
    this.toggleEditForm(event.target);
  }

  displayEditForm(event) {
    this.toggleEditForm(event.target.parentElement);
  }

  displayErrorMessage(errorMessage) {
    if (errorMessage != '') {
      M.toast({ html: errorMessage });
    }
  }

  getEditForm(courseModuleId) {
    const siblings = element => Array.from(element.parentElement.children);
    const findByModuleId = targets => {
      return targets.find(element => this.getCourseModuleId(element) == courseModuleId);
    } 

    const updateButton = findByModuleId(this.updateButtonTargets);
    const nameField = findByModuleId(this.nameTargets);
    
    updateButton.siblings = siblings(updateButton.parentElement);
    nameField.siblings = siblings(nameField);

    return { updateButton: updateButton, nameField: nameField };
  }
  
  getCourseModuleId(element) {
    return element.dataset.courseModuleId;
  }
}
