import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-filter"
export default class extends Controller {

  static targets = ["from", "until", "jobs"]

  connect() {
  }

  filterJobs(){

    console.log("FilterJobs action clicked");

    const from = this.fromTarget.value;
    const until = this.untilTarget.value;

    console.log(from);
    console.log(until);

    // Make an AJAX request to your Rails controller
    fetch(`/dashboards?from_date=${from}&until_date=${until}.json`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    })
      .then(response => response.json())
      .then(data => {
        console.log(data);
        this.updateJobs(data);
      })
      .catch(error => console.error("Error:", error));
  }

  updateJobs(data){
    console.log("Update Jobs Called");
    console.log(data.jobs);
    this.jobsTarget.innerHTML = '';

    data.jobs.foreach(job => {
      console.log(job);
    })

  }
}
