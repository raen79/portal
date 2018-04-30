import { Controller } from 'stimulus'

export class TableController extends Controller {
  static targets = ['editError', 'newError', 'updateButton', 'modal', 'editForm'];

  initialize() {
    const notice = this.data.get('notice');

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
    if (this.newErrorTargets.length > 0) {
      M.Modal.getInstance(this.modalTarget).open();
    }
  }

  submitEditForm(event) {
    const objectId = this.getObjectId(event.target);
    this.editFormTargets.find(element => element.dataset.objectId == objectId).submit();
  }

  toggleEditForm(formElement) {
    const objectId = this.getObjectId(formElement);
    const form = this.getEditForm(objectId);
    
    Object.values(form).forEach(formElement => {
      formElement.siblings.forEach(element => element.classList.toggle('hide'));
    });
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

  getEditForm(objectId) {
    const siblings = element => Array.from(element.parentElement.children);
    const findByModuleId = targets => {
      return targets.find(element => this.getObjectId(element) == objectId);
    } 

    let form = {};

    const updateButton = findByModuleId(this.updateButtonTargets);
    updateButton.siblings = siblings(updateButton.parentElement);
    form.updateButton = updateButton;

    this.fieldTargets.forEach(fieldTarget => {
      let field = findByModuleId(fieldTarget.targets);
      field.siblings = siblings(field);
      form[fieldTarget.name] = field;
    });

    return form;
  }
  
  getObjectId(element) {
    return element.dataset.objectId;
  }

  get fieldTargets() {
    throw new Error('Getter fieldTargets() is not implemented!');
  }
}
