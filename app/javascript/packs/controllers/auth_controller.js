import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['lecturerField', 'studentField', 'lecturerToggle', 'studentToggle'];
  
  toggleLecturer() {
    if (this.lecturerToggleTarget.checked == true) {
      this.studentFieldTarget.value = '';
      this.studentFieldTarget.parentElement.classList.add('hide');
      this.lecturerFieldTarget.parentElement.classList.remove('hide');
    }

    else {
      this.lecturerFieldTarget.value = '';
      this.lecturerFieldTarget.parentElement.classList.add('hide');
      this.studentFieldTarget.parentElement.classList.remove('hide');      
    }
  }
}
