use std::fs;
use std::str::Split;

const FILE_PATH: &str = "data.txt";

fn add_pot_max(value: u32, max_calories: &mut [u32; 3]) {
    if value > max_calories[0] {
       max_calories.rotate_right(1);
       max_calories[0] = value;
    } else if value > max_calories[1] {
        max_calories[2] = max_calories[1];
        max_calories[1] = value;
    } else if value > max_calories[2] {
        max_calories[2] = value;
    }
}

fn main() {
    let mut max_calories: [u32; 3] = [u32::MIN, u32::MIN, u32::MIN];

    let data: String = fs::read_to_string(FILE_PATH).expect("Welp no file for you today!");
    
    // shadow var containing string
    let data: Split<&str> = data.split("\n");

    let mut current_calories: u32 = 0;

    for val in data {
        if val == "" {
            add_pot_max(current_calories, &mut max_calories);
            current_calories = 0;
        } else {
            current_calories += val.parse::<u32>().unwrap();
        }
    }

    println!("{}", max_calories.iter().sum::<u32>());
}
