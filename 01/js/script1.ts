import { readFileSync } from "fs";

const data: string = readFileSync("data.txt").toString();
const cals: string[] = data.split("\n");

let maxCal: number = -Infinity;
let currentCals: number = 0;

cals.forEach((val: string) => {
  if (val === "") {
    if (currentCals > maxCal) {
      maxCal = currentCals;
    }

    currentCals = 0;
  } else {
    currentCals += parseInt(val);
  }
});
console.log(maxCal);
