import { Application } from "@hotwired/stimulus";
import PasswordToggleController from "../password_toggle_controller";

describe("PasswordToggleController", () => {
  let application;
  let element;

  beforeEach(() => {
    element = document.createElement("div");
    element.innerHTML = `
      <div data-controller="password-toggle">
        <input type="password"
          data-password-toggle-target="input"
          placeholder="••••••••">
        <button type="button" 
          data-action="click->password-toggle#toggle">
          <span data-password-toggle-target="icon">
            <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
          </span>
        </button>
      </div>
    `;
    document.body.appendChild(element);

    application = Application.start();
    application.register("password-toggle", PasswordToggleController);
  });

  afterEach(() => {
    document.body.removeChild(element);
  });

  describe("toggle", () => {
    it("cambia la visibilidad de la contraseña", () => {
      const input = element.querySelector(
        "[data-password-toggle-target='input']"
      );
      const button = element.querySelector("button");
      const controller = application.getControllerForElementAndIdentifier(
        element.firstElementChild,
        "password-toggle"
      );

      expect(input.type).toBe("password");

      button.click();
      expect(input.type).toBe("text");

      button.click();
      expect(input.type).toBe("password");
    });

    it("actualiza el icono al cambiar la visibilidad", () => {
      const icon = element.querySelector(
        "[data-password-toggle-target='icon']"
      );
      const button = element.querySelector("button");
      const controller = application.getControllerForElementAndIdentifier(
        element.firstElementChild,
        "password-toggle"
      );

      expect(icon.querySelector("svg")).toBeTruthy();
      expect(icon.innerHTML).toContain("M15 12a3 3 0 11-6 0 3 3 0 016 0z");

      button.click();
      expect(icon.innerHTML).not.toContain("M15 12a3 3 0 11-6 0 3 3 0 016 0z");
      expect(icon.innerHTML).toContain("M13.875 18.825");
    });
  });
});
