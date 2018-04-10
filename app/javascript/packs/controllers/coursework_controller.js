import { Controller } from 'stimulus'
import { TableController } from './table_controller'

export default class extends TableController {
  static targets = [...TableController.targets, ...['name']];

  get fieldTargets() {
    return [{ name: 'name', targets: this.nameTargets }];
  }
}
