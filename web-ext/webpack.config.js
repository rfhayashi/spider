module.exports = [
  {
    mode: "production",
    entry: {
      index: "./squint_output/index.mjs"
    },
    output: {
      filename: "index.js"
    }
  },
  {
    mode: "production",
    entry: {
      index: "./squint_output/index_test.mjs"
    },
    output: {
      filename: "index.test.js"
    }
  }
]
