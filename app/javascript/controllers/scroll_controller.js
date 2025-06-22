import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver((entries) => {
      if (entries[0].isIntersecting) {
        entries[0].target.querySelector('turbo-frame')?.click()
      }
    })
    this.observer.observe(this.element)
  }
}
