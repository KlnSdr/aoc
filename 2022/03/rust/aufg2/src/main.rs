use std::fs;

const FILE_NAME: &str = "data.txt";

fn main() {
    let data: String = fs::read_to_string(FILE_NAME).expect("no file found");
    let data: Vec<&str> = data.lines().collect();

    let mut sum: u32 = 0;

    for i in 0..data.len()/3 {
        for chr in data[i * 3].chars() {
            if data[i * 3 + 1].contains(chr) && data[i * 3 + 2].contains(chr) {
                sum += get_value(chr) as u32;
                break;
            }
        }
    }

    println!("===\n{sum}");
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
