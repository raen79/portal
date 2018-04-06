import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['error', 'updateButton', 'name', 'cancelButton'];

  initialize() {
    const notice = this.data.get("notice");

    this.displayErrorMessage(notice);
    this.initializeForms();
  }

  initializeForms() {
    this.errorTargets.forEach(errorElement => {
      this.displayErrorMessage(errorElement.dataset.errorMessage);

      if (this.hasErrorMessage(errorElement)) {
        this.displayForm(errorElement);
      }
    });
  }

  displayForm(formElement) {
    const courseModuleId = this.getCourseModuleId(formElement);
    const form = this.getForm(courseModuleId);

    form.updateButton.siblings.forEach(element => element.classList.add('hide'));
    form.updateButton.parentElement.classList.remove('hide');
    form.cancelButton.classList.remove('hide');

    form.nameField.siblings.forEach(element => element.classList.add('hide'))
    form.nameField.classList.remove('hide');
  }

  hideForm(event) {
    const formElement = event.target;

    const courseModuleId = this.getCourseModuleId(formElement);
    const form = this.getForm(courseModuleId);

    form.updateButton.siblings.forEach(element => element.classList.remove('hide'));
    form.updateButton.parentElement.classList.add('hide');
    form.cancelButton.classList.add('hide');

    form.nameField.siblings.forEach(element => element.classList.remove('hide'))
    form.nameField.classList.add('hide');
  }

  displayFormEvent(event) {
    this.displayForm(event.target.parentElement);
  }

  displayErrorMessage(errorMessage) {
    if (errorMessage != '') {
      // M.toast({ html: errorMessage });
      console.log(errorMessage);
    }
  }

  getForm(courseModuleId) {
    const siblings = element => Array.from(element.parentElement.children);
    const findByModuleId = targets => {
      return targets.find(element => this.getCourseModuleId(element) == courseModuleId);
    } 

    const updateButton = findByModuleId(this.updateButtonTargets);
    const cancelButton = findByModuleId(this.cancelButtonTargets);
    const nameField = findByModuleId(this.nameTargets);
    
    
    updateButton.siblings = siblings(updateButton.parentElement);
    cancelButton.siblings = siblings(cancelButton);
    nameField.siblings = siblings(nameField);

    return { updateButton: updateButton, nameField: nameField, cancelButton: cancelButton };
  }

  hasErrorMessage(formElement) {
    const courseModuleId = this.getCourseModuleId(formElement);

    const errorElement = this.errorTargets.find(element => {
      return this.getCourseModuleId(element) == courseModuleId;
    });

    return errorElement.dataset.errorMessage != '';
  }
  
  getCourseModuleId(element) {
    return element.dataset.courseModuleId;
  }
}
