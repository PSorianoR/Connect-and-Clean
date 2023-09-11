import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"

export default class extends Controller {
  static values = { 'input': Object}

  connect() {
    new TomSelect(this.element, this.inputValue)
  }
}
