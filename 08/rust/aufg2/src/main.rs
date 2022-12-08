use std::{fs, str::Lines};

const IS_TEST: bool = false;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST { ".test" } else { "" });

    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Lines = data.lines();

    let mut forest: Vec<Vec<u32>> = vec![];
    let mut max_scenic_score: u32 = 0;

    for (index, line) in data.enumerate() {
        forest.push(vec![]);
        for chr in line.chars() {
            forest[index].push(chr.to_string().parse::<u32>().unwrap());
        }
    }

    for y in 0..forest.len() {
        for x in 0..forest[y].len() {
            //let y: usize = 1;
            //let x: usize = 2;

            // println!(" {} ", forest[y - 1][x]);
            // println!("{}{}{}", forest[y][x - 1], forest[y][x], forest[y][x + 1]);
            // println!(" {} ", forest[y + 1][x]);

            let mut scenic_score: u32 = 1;
            let mut tmp_scenic_score: u32 = 0;
            for index in (0..x).rev() {
                if index != x {
                    tmp_scenic_score += 1;
                }
                // println!("{}", forest[y][index]);
                if forest[y][index] >= forest[y][x] && index != x {
                    break;
                }
            }
            // println!("left: {tmp_scenic_score}");

            scenic_score *= tmp_scenic_score;
            tmp_scenic_score = 0;

            for index in x..forest[y].len() {
                if index != x {
                    tmp_scenic_score += 1;
                }
                // println!("{}", forest[y][index]);
                if forest[y][index] >= forest[y][x] && index != x {
                    break;
                }
            }
            // println!("right: {tmp_scenic_score}");

            scenic_score *= tmp_scenic_score;
            tmp_scenic_score = 0;

            for index in (0..y).rev() {
                if index != y {
                    tmp_scenic_score += 1;
                }
                // println!("{}", forest[index][x]);
                if forest[index][x] >= forest[y][x] && index != y {
                    break;
                }
            }
            // println!("top: {tmp_scenic_score}");

            scenic_score *= tmp_scenic_score;
            tmp_scenic_score = 0;

            for index in y..forest.len() {
                if index != y {
                    tmp_scenic_score += 1;
                }
                // println!("{}", forest[index][x]);
                if forest[index][x] >= forest[y][x] && index != y {
                    break;
                }
            }
            // println!("bottom: {tmp_scenic_score}");

            scenic_score *= tmp_scenic_score;
            // println!("{} => {}", forest[y][x], scenic_score);
            if scenic_score > max_scenic_score {
                max_scenic_score = scenic_score;
            }
        }
    }

    println!("scenic_score = {max_scenic_score}");
}
