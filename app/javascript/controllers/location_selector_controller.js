import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option"]

  select(event) {
    this.optionTargets.forEach((option) => {
      const container = option.closest(".list-group-item")
      if (container) {
        container.classList.remove("active")
      }
      option.removeAttribute("aria-current")
    })

    const currentLabel = event.currentTarget.closest("label")
    const currentContainer = event.currentTarget.closest(".list-group-item")

    if (currentContainer) {
      currentContainer.classList.add("active")
    }
    
    if (currentLabel) {
      currentLabel.setAttribute("aria-current", "true")
    }
  }
}
