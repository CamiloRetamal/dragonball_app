// Mock para MutationObserver que requiere Stimulus
global.MutationObserver = class {
  constructor(callback) {
    this.callback = callback;
  }
  disconnect() {}
  observe(element, initObject) {}
  takeRecords() {
    return [];
  }
};

// Mock para ResizeObserver que podría requerir Stimulus
global.ResizeObserver = class {
  constructor(callback) {
    this.callback = callback;
  }
  disconnect() {}
  observe(element, initObject) {}
  unobserve(element) {}
};
