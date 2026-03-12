/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: "#111111",
        secondary: "#222222",
        accent: "#646cff",
        background: "#181818",
      },
    },
  },
  plugins: [],
};
