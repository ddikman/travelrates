// helper function to indent all lines in a block of text
module.exports = function (text, indentation) {
  indentation = ' '.repeat(indentation)
  return text.replace(/^(?=.)/gm, indentation)
}
