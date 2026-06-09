import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._applyFormat()
  }

  format() {
    this._applyFormat()
  }

  _applyFormat() {
    const input = this.element
    const cursor = input.selectionStart
    const digitsBeforeCursor = input.value.slice(0, cursor).replace(/\D/g, '').length

    const raw = input.value.replace(/\D/g, '').slice(0, 11)
    let formatted = raw
    if (raw.length > 2)  formatted = raw.slice(0, 2) + '-' + raw.slice(2)
    if (raw.length > 10) formatted = raw.slice(0, 2) + '-' + raw.slice(2, 10) + '-' + raw.slice(10)

    if (input.value !== formatted) {
      input.value = formatted
      let newPos = 0, count = 0
      for (let i = 0; i < formatted.length; i++) {
        if (/\d/.test(formatted[i])) count++
        if (count === digitsBeforeCursor) { newPos = i + 1; break }
      }
      if (count < digitsBeforeCursor) newPos = formatted.length
      input.setSelectionRange(newPos, newPos)
    }
  }
}
