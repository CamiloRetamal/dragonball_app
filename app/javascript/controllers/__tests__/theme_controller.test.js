import ThemeController from "../theme_controller";

describe("ThemeController", () => {
  let controller;

  beforeEach(() => {
    document.documentElement.classList.remove("dark");
    localStorage.clear();

    controller = new ThemeController();
  });

  describe("toggle()", () => {
    it("alterna entre tema claro y oscuro", () => {
      expect(document.documentElement.classList.contains("dark")).toBe(false);

      controller.toggle();
      expect(document.documentElement.classList.contains("dark")).toBe(true);
      expect(localStorage.getItem("theme")).toBe("dark");

      controller.toggle();
      expect(document.documentElement.classList.contains("dark")).toBe(false);
      expect(localStorage.getItem("theme")).toBe("light");
    });

    it("maneja las clases de transición correctamente", () => {
      jest.useFakeTimers();

      controller.toggle();
      expect(
        document.documentElement.classList.contains("transition-colors")
      ).toBe(true);
      expect(document.documentElement.classList.contains("duration-300")).toBe(
        true
      );

      jest.advanceTimersByTime(300);
      expect(
        document.documentElement.classList.contains("transition-colors")
      ).toBe(false);
      expect(document.documentElement.classList.contains("duration-300")).toBe(
        false
      );

      jest.useRealTimers();
    });
  });

  describe("initializeTheme()", () => {
    it("aplica tema oscuro cuando está guardado en localStorage", () => {
      localStorage.setItem("theme", "dark");
      controller.initializeTheme();
      expect(document.documentElement.classList.contains("dark")).toBe(true);
    });

    it("aplica tema claro cuando está guardado en localStorage", () => {
      localStorage.setItem("theme", "light");
      controller.initializeTheme();
      expect(document.documentElement.classList.contains("dark")).toBe(false);
    });
  });
});
