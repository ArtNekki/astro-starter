import "@testing-library/jest-dom";
import { cleanup } from "@testing-library/react";

if (typeof window === "undefined") {
  console.log("Node environment");
  // Settings specific to Node.js environment
  afterEach(() => {
    console.log("Cleanup for Node environment");
    // Here you can add Node-specific cleanup if necessary
  });
} else {
  console.log("JSDOM environment");

  afterEach(() => {
    console.log("Cleanup for JSDOM environment");
    cleanup();
  });

  // Additional settings for the browser environment
  Object.defineProperty(window, "matchMedia", {
    writable: true,
    value: vi.fn().mockImplementation((query: string) => ({
      matches: false,
      media: query,
      onchange: null,
      addListener: vi.fn(),
      removeListener: vi.fn(),
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
      dispatchEvent: vi.fn(),
    })),
  });
}

// Global mocks or other settings common to both environments
vi.mock("some-module", () => {
  return {
    someFunction: vi.fn(),
  };
});
