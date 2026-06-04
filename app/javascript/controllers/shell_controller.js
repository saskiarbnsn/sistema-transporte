import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

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
    if (!this.hasBadgeTarget) return
    this.badgeTarget.remove()
  }

  initTooltips() {
    const items = this.element.querySelectorAll('[data-bs-toggle="tooltip"]')
    this.tooltips = Array.from(items).map(el => {
      const t = new Tooltip(el, { trigger: "hover", container: "body", placement: "right" })
      if (this.element.classList.contains("is-expanded")) t.disable()
      return t
    })
  }
}
