import { readFileSync } from "fs";

const data: string = readFileSync("data.txt").toString();
const cals: string[] = data.split("\n");

let maxCal: number[] = [-Infinity, -Infinity, -Infinity];
let currentCals: number = 0;

function addPotMax(value: number) {
  if (value > maxCal[0]) {
    maxCal = [value, ...maxCal];
    maxCal.pop();
  } else if (value > maxCal[1]) {
    maxCal = [maxCal[0], value, maxCal[1]];
  } else if (value > maxCal[2]) {
    maxCal[2] = value;
  }
}

cals.forEach((val: string) => {
  if (val === "") {
    addPotMax(currentCals);
    currentCals = 0;
  } else {
    currentCals += parseInt(val);
  }
});

console.log(
  maxCal.reduce((sum: number, val: number) => {
    return sum + val;
  }, 0)
);
