import {defineConfig, envField} from 'astro/config';
import tailwind from "@astrojs/tailwind";

import react from "@astrojs/react";

// https://astro.build/config
export default defineConfig({
  experimental: {
    env: {
      schema: {
        STRAPI_URL: envField.string({
          context: 'client',
          access: 'public',
          default: 'not set'
        }),
        NODE_ENV: envField.string({
          context: 'client',
          access: 'public',
          default: 'not set'
        }),
        DOPPLER_CONFIG: envField.string({
          context: 'client',
          access: 'public',
          default: 'not set'
        }),
      }
    }
  },
  integrations: [tailwind(), react()]
});
