import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-jobs"
export default class extends Controller {

  static targets = ["jobsOfStatus"];

  connect() {
    console.log("Controller Connected");
  }

  filter(event){

    console.log("Button clicked");
    let filterType = event.target.dataset.filter;
    console.log(filterType);

    fetch(`/jobs/${filterType}`)
    .then(response => response.text())
    .then(html => {
      this.jobsOfStatusTarget.innerHTML = ``;
      this.jobsOfStatusTarget.innerHTML = html
    })
  }
}
