const modulePatterns = [
  "(jest-)?react-native",
  "react-clone-referenced-element",
  "@react-native-community",
  "expo(nent)?",
  "@expo(nent)?/.*",
  "react-navigation",
  "@react-navigation/.*",
  "@unimodules/.*",
  "unimodules",
  "sentry-expo",
  "native-base",
  "@sentry/.*",
  "@react-native/polyfills/.*",
  "@react-native-async-storage/.*"
]

module.exports = {
  preset: "jest-expo",
  transformIgnorePatterns: [
    `node_modules/(?!${modulePatterns.join("|")})`
  ],
  moduleFileExtensions: ["ts", "tsx", "js", "jsx"],
  transform: {
    '^.*\\.jsx?$': 'babel-jest'
  },
  setupFiles: ["./path/to/jestSetupFile.js"]
}