import { getViteConfig, ViteUserConfig } from "astro/config";

export default getViteConfig({
  test: {
    // Common settings
    globals: true,
    setupFiles: ["./tests/setup.ts"],
    include: ["tests/**/*.{test,spec}.{js,ts, jsx,tsx}"],
    exclude: ["node_modules", "dist", ".idea", ".git", ".cache"],
    testTimeout: 10000,

    // node environment by default
    // environment: 'node' - it's no need to set here

    // Environment settings
    environmentOptions: {
      jsdom: {
        url: "http://localhost:4321/",
        contentType: "text/html",
        // includeNodeLocations: true,
        // storageQuota: 10000000,
        // resources: 'usable',
        // runScripts: 'dangerously',
      },
      node: {
        env: {
          NODE_ENV: "test",
        },
      },
    },
    environmentMatchGlobs: [
      ["tests/jsdom/**/*.test.*", "jsdom"],
      ["tests/node/**/*.test.*", "node"],
    ],
  },
} as ViteUserConfig);
