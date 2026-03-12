require("dotenv").config();
const http = require("http");
const handler = require("./index");

const server = http.createServer(handler);

server.listen(3001, () => {
  console.log("API running at http://localhost:3001");
});
