use std::fs;
use std::str::Split;

const FILE_PATH: &str = "data.txt";

fn main() {
    let data: String = fs::read_to_string(FILE_PATH).expect("Welp no file for you today!");
    
    // shadow var containing string
    let data: Split<&str> = data.split("\n");

    let mut max_calories: u32 = std::u32::MIN;
    let mut current_calories: u32 = 0;

    for val in data {
        if val == "" {
            if current_calories > max_calories {
                max_calories = current_calories;
            }
            current_calories = 0;
        } else {
            current_calories += val.parse::<u32>().unwrap();
        }
    }

    println!("{max_calories}");
}
