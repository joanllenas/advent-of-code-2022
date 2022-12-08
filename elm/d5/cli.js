const fs = require("fs");

const input = fs.readFileSync("d5/input.txt", "utf-8");

const Elm = require("./main").Elm;
const main = Elm.Day5.init();
main.ports.getInput.send(input);
main.ports.sendResult.subscribe(function (data) {
  console.log("Result: " + JSON.stringify(data) + "\n");
});
