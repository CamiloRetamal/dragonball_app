import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  toggle() {
    document.documentElement.classList.add("transition-colors", "duration-300");

    if (document.documentElement.classList.contains("dark")) {
      document.documentElement.classList.remove("dark");
      localStorage.theme = "light";
    } else {
      document.documentElement.classList.add("dark");
      localStorage.theme = "dark";
    }

    setTimeout(() => {
      document.documentElement.classList.remove(
        "transition-colors",
        "duration-300"
      );
    }, 300);
  }
}
