"use strict";
process.chdir("fn");
const fs = require('fs')
const handler = require("fn");
const express = require("express");
const bodyParser = require("body-parser")
const app = express();
console.log("Here")
function readFirstLineSync(filePath) {
  try {
      // Read the entire file synchronously
      const content = fs.readFileSync(filePath, 'utf8');

      // Split the content into lines and return the first line
      const firstLine = content.split('\n')[0];

      return firstLine;
  } catch (err) {
      // Handle any errors
      console.error('Error reading file synchronously:', err);
      return null;
  }
}

const port = readFirstLineSync("/usr/src/app/ports.txt");
console.log("Port in functionHandler: " + port)
app.use(bodyParser.text({
    type: function(req) {
        return 'text';
    }
}));

app.all("/health", (req, res) => {
  return res.send("OK");
});
app.all("/fn", handler);
app.listen(port);