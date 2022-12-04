const fs = require("fs");

const input = fs.readFileSync("d2/input.txt", "utf-8");

const Elm = require("./main").Elm;
const main = Elm.Day2.init();
main.ports.getInput.send(input);
main.ports.sendResult.subscribe(function (data) {
  console.log("Result: " + JSON.stringify(data) + "\n");
});
