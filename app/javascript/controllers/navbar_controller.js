import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {

  static targets = ["myProperties","cleanerLinkText", "managerLinkText"]

  connect() {

    if (localStorage.getItem("mode") === "manager") {
      this.enableManagerMode()
    } else{
      this.disableManagerMode()
    }
  }

  enableManagerMode() {
    this.myPropertiesTarget.classList.remove("d-none")
    this.cleanerLinkTextTarget.classList.add("d-none")
    this.managerLinkTextTarget.classList.remove("d-none")

    // Only if the page is not refreshed, but the action is invoked by accessing through data-action
    // Redirect to jobs page
    if (localStorage.getItem("mode") !== "manager") {
      localStorage.setItem("mode", "manager")
      this.#setRole()
      window.location.href = '/dashboards';
    }else{
      localStorage.setItem("mode", "manager")
      this.#setRole()
    }
  }

  disableManagerMode() {
    this.myPropertiesTarget.classList.add("d-none")
    this.cleanerLinkTextTarget.classList.remove("d-none")
    this.managerLinkTextTarget.classList.add("d-none")

    // Only if the page is not refreshed, but the action is invoked by accessing through data-action
    // Redirect to jobs page
    if (localStorage.getItem("mode") !== "cleaner") {
      localStorage.setItem("mode", "cleaner")
      this.#setRole()
      window.location.href = '/dashboards';
    }else{
      localStorage.setItem("mode", "cleaner")
      this.#setRole()
    }
  }

  #setRole() {
    const mode = localStorage.getItem("mode")
    const csrfToken = document.querySelector('[name=csrf-token]').content;

    const timestamp = new Date().getTime(); // This gets the current timestamp in milliseconds.

    fetch(`/mode?timestamp=${timestamp}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ role: mode }),
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log("Selected role sent to server successfully", data)

        Turbolinks.visit(window.location, { action: "replace" });
      })
      .catch(error => {
        console.error("Error:", error);
      });

  }
}
