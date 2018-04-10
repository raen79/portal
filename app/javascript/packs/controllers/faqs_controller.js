import { Controller } from 'stimulus'
import { TableController } from './table_controller'

export default class extends TableController {
  static targets = [...TableController.targets, ...['question', 'answer']];

  get fieldTargets() {
    return [
      { name: 'question', targets: this.questionTargets },
      { name: 'answer', targets: this.answerTargets }
    ];
  }
}
