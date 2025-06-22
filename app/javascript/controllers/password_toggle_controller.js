import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['input', 'icon']

  connect() {
    this.updateIcon(this.inputTarget.type === 'password')
  }

  toggle(event) {
    event.preventDefault()
    const isPassword = this.inputTarget.type === 'password'
    this.inputTarget.type = isPassword ? 'text' : 'password'
    this.updateIcon(!isPassword)
  }

  updateIcon(isPassword) {
    while (this.iconTarget.firstChild) {
      this.iconTarget.removeChild(this.iconTarget.firstChild)
    }

    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg')
    svg.setAttribute('class', 'h-5 w-5 cursor-pointer')
    svg.setAttribute('fill', 'none')
    svg.setAttribute('viewBox', '0 0 24 24')
    svg.setAttribute('stroke', 'currentColor')

    if (isPassword) {
      const path1 = document.createElementNS(
        'http://www.w3.org/2000/svg',
        'path'
      )
      path1.setAttribute('stroke-linecap', 'round')
      path1.setAttribute('stroke-linejoin', 'round')
      path1.setAttribute('stroke-width', '2')
      path1.setAttribute('d', 'M15 12a3 3 0 11-6 0 3 3 0 016 0z')

      const path2 = document.createElementNS(
        'http://www.w3.org/2000/svg',
        'path'
      )
      path2.setAttribute('stroke-linecap', 'round')
      path2.setAttribute('stroke-linejoin', 'round')
      path2.setAttribute('stroke-width', '2')
      path2.setAttribute(
        'd',
        'M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z'
      )

      svg.appendChild(path1)
      svg.appendChild(path2)
    } else {
      const path = document.createElementNS(
        'http://www.w3.org/2000/svg',
        'path'
      )
      path.setAttribute('stroke-linecap', 'round')
      path.setAttribute('stroke-linejoin', 'round')
      path.setAttribute('stroke-width', '2')
      path.setAttribute(
        'd',
        'M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21'
      )

      svg.appendChild(path)
    }

    this.iconTarget.appendChild(svg)
  }
}
