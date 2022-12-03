use std::fs;
use std::str::Lines;

const FILE_NAME: &str = "data.txt";

fn main() {
    let data: String = fs::read_to_string(FILE_NAME).expect("no file found");
    let data: Lines = data.lines();

    let mut sum: u32 = 0;

    for line in data {
        let len: usize = line.len();
        let comps: (&str, &str) = line.split_at(len/2);
        println!("{} + {}", comps.0, comps.1);

        for item in comps.0.chars() {
            if comps.1.contains(item) {
                sum += get_value(item) as u32;
                break;
            }
        }
    }

    println!("{sum}");
}

fn get_value(chr: char) -> usize {
    const LWR: &str = "abcdefghijklmnopqrstuvwxyz";
    const UPPER: &str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    if LWR.contains(chr) {
        LWR.find(chr).unwrap() + 1
    } else if UPPER.contains(chr) {
        26 + UPPER.find(chr).unwrap() + 1
    } else {
        0
    }
}
