import daisyui from "daisyui";
import { fontFamily } from 'tailwindcss/defaultTheme';

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["../lib/elixir_jwt_auth_protected_route/web/templates/**/*.html.eex"],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Merriweather Sans', ...fontFamily.sans]
      }
    },
  },
  plugins: [daisyui],
  daisyui: {
    themes: ["dark"]
  },
}

