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
    if (opponent == "A" && me == "X") || (opponent == "B" && me == "Y") || (opponent == "C" && me == "Z") {
        return 3 + get_value(me);
    } else if (opponent == "A" && me == "Y") || (opponent == "B" && me == "Z") || (opponent == "C" && me == "X") {
        return 6 + get_value(me);
    } else {
        return get_value(me);
    }
}

fn get_value(choice: &str) -> u32 {
    match choice {
        "X" => return 1,
        "Y" => return 2,
        "Z" => return 3,
        _ => return 0
    }
 }
