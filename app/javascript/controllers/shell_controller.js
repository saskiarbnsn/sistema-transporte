import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "badge"]

  connect() {
    this.initTooltips()
  }

  toggle() {
    const expanded = this.element.classList.toggle("is-expanded")
    this.tooltips?.forEach(t => expanded ? t.disable() : t.enable())
  }

  clearBadge() {
    if (this.hasBadgeTarget) this.badgeTarget.remove()
  }

  initTooltips() {
    if (!window.bootstrap?.Tooltip) return

    const items = this.element.querySelectorAll('[data-bs-toggle="tooltip"]')
    this.tooltips = Array.from(items).map(el => {
      const t = new bootstrap.Tooltip(el, { trigger: 'hover' })
      // Disable if already expanded
      if (this.element.classList.contains('is-expanded')) t.disable()
      return t
    })
  }
}
