use std::fs;
use std::str::Lines;

const FILE_PATH: &str = "data.txt";

fn main() {
    let mut score: u32 = 0;
    let data: String = fs::read_to_string(FILE_PATH).expect("no file dumbass!");
    let data: Lines = data.lines();

    for line in data {
        if line != "" {
            let pair: Vec<&str> = line.split(" ").collect();

            let opponent: &str = pair[0];
            let my_turn: &str = pair[1];
            score += calc_score(opponent, my_turn);
        }
    }

    println!("{score}");
}

fn calc_score(opponent: &str, me: &str) -> u32 {
    match me {
        "X" => { // loose
            if opponent == "A" {
                return get_value("SCISSORS");
            } else if opponent == "B" {
                return get_value("ROCK");
            } else if opponent == "C" {
                return get_value("PAPER");
            } else {
                return 0;
            }
        },
        "Y" => { // draw
            if opponent == "A" {
                return 3 + get_value("ROCK");
            } else if opponent == "B" {
                return 3 + get_value("PAPER");
            } else if opponent == "C" {
                return 3 + get_value("SCISSORS");
            } else {
                return 0;
            }
        },
        "Z" => { // win
            if opponent == "A" {
                return 6 + get_value("PAPER");
            } else if opponent == "B" {
                return 6 + get_value("SCISSORS");
            } else if opponent == "C" {
                return 6 + get_value("ROCK");
            } else {
                return 0;
            }
        },
        _ => return 0
    }
}

fn get_value(turn: &str) -> u32 {
    match turn {
        "ROCK" => return 1,
        "PAPER" => return 2,
        "SCISSORS" => return 3,
        _ => return 0
    }
}
