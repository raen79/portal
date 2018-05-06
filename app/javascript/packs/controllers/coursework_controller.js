import { Controller } from 'stimulus'
import { TableController } from './table_controller'

export default class extends TableController {
  static targets = [...TableController.targets, ...['name', 'textualFile', 'codeFile', 'testsFile']];

  initialize() {
    super.initialize();

    document.querySelectorAll('.dropdown-trigger').forEach(elem => {
      M.Dropdown.init(elem, {});
    });
  }

  submitTextualFile(event) {
    this.findButton(event.target, this.textualFileTargets).click();
  }

  uploadTextualFile(event) {
    this.submitForm(this.findButton(event.target, this.textualFileTargets), event.target.dataset.url);
  }

  submitCodeFile(event) {
    this.findButton(event.target, this.codeFileTargets).click();
  }

  uploadCodeFile(event) {
    this.submitForm(this.findButton(event.target, this.codeFileTargets), event.target.dataset.url);
  }

  submitTests(event) {
    this.findButton(event.target, this.testsFileTargets).click();
  }

  uploadTests(event) {
    this.submitForm(this.findButton(event.target, this.testsFileTargets), event.target.dataset.url);
  }

  findButton(target, buttons) {
    const id = target.dataset.id;
    const button = buttons.find(uploadButton => uploadButton.dataset.id == id);
    return button;
  }

  submitForm(button, url) {
    const form = document.createElement('form');
    const csrf = document.head.querySelector('[name="csrf-token"]').content;
    const input = document.createElement('input');

    input.type = 'hidden';
    input.name = 'authenticity_token';
    input.value = csrf;

    form.method = 'POST';
    form.action = url;
    form.enctype = 'multipart/form-data';

    form.appendChild(button);
    form.appendChild(input);

    document.body.appendChild(form);
    form.submit();
  }

  get fieldTargets() {
    return [{ name: 'name', targets: this.nameTargets }];
  }
}
