use std::fs;
use std::str::Lines;

const FILE_PATH: &str = "data.txt";

fn main() {
    let mut score: u32 = 0;

    let data: String = fs::read_to_string(FILE_PATH).expect("no file found");
    let data: Lines = data.lines();

    for line in data {
        let comma_index: usize = line.find(",").unwrap();
        let mut elves: (&str, &str) = line.split_at(comma_index);
        elves.1 = elves.1.split_at(1).1; // remove comma from start
        
        let elve_0: Vec<u32> = elves.0.split("-").map(|x| x.parse::<u32>().unwrap()).collect();
        let elve_1: Vec<u32> = elves.1.split("-").map(|x| x.parse::<u32>().unwrap()).collect();

        if  ((elve_1[0] <= elve_0[0] && elve_0[0] <= elve_1[1]) && (elve_1[0] <= elve_0[1] && elve_0[1] <= elve_1[1]))
            || 
            ((elve_0[0] <= elve_1[0] && elve_1[0] <= elve_0[1]) && (elve_0[0] <= elve_1[1] && elve_1[1] <= elve_0[1])) {
            score += 1;
        }
    }

    println!("{score}");
}
