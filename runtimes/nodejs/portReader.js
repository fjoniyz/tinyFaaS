const fs = require('fs');

const http_port = "" + parseInt(process.env.HTTP_PORT) + "\n";
fs.writeFileSync('runtimes/nodejs/ports.txt', http_port);
