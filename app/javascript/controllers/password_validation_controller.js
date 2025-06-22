import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'requirement']

  connect() {
    this.validate()
  }

  validate() {
    const password = this.inputTarget.value
    const requirements = {
      length: password.length >= 8,
      uppercase: /[A-Z]/.test(password),
      lowercase: /[a-z]/.test(password),
      number: /[0-9]/.test(password)
    }

    this.requirementTargets.forEach((element, index) => {
      if (Object.values(requirements)[index]) {
        element.classList.remove('text-gray-600', 'dark:text-gray-300')
        element.classList.add('text-green-600', 'dark:text-green-400')
      } else {
        element.classList.remove('text-green-600', 'dark:text-green-400')
        element.classList.add('text-gray-600', 'dark:text-gray-300')
      }
    })
  }
}
