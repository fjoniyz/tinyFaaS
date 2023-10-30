"use strict";
process.chdir("fn");

const handler = require("fn");
const express = require("express");
const app = express();
const http_port = parseInt(process.env.HTTP_PORT);

app.all("/health", (req, res) => {
  return res.send("OK");
});
app.all("/fn", handler);
app.listen(http_port);
