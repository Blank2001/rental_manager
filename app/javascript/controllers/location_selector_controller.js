import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option"]

  select(event) {
    this.optionTargets.forEach((option) => {
      option.classList.remove("active")
      option.removeAttribute("aria-current")
    })

    const selectedOption = event.target.closest(".location-option") ||
                           event.target.closest("label")

    selectedOption.classList.add("active")
    selectedOption.setAttribute("aria-current", "true")
  }
}