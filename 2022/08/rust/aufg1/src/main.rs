use std::{fs, str::Lines};

const IS_TEST: bool = false;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST { ".test" } else { "" });

    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Lines = data.lines();

    let mut forest: Vec<Vec<u32>> = vec![];
    let mut visibilities: Vec<Vec<bool>> = vec![];
    let mut visible_trees: u32 = 0;

    for (index, line) in data.enumerate() {
        forest.push(vec![]);
        visibilities.push(vec![]);
        for chr in line.chars() {
            forest[index].push(chr.to_string().parse::<u32>().unwrap());
            visibilities[index].push(false);
        }
    }

    for y in 0..forest.len() {
        for x in 0..forest[y].len() {
            if x == 0 || x == forest[y].len() - 1 || y == 0 || y == forest.len() - 1 {
                visibilities[y][x] = true;
            } else {
                let mut vis_left: bool = true;

                for index in 0..x {
                    if forest[y][index] >= forest[y][x] && index != x {
                        vis_left = false;
                    }
                }


                let mut vis_right: bool = true;
                for index in x..forest[y].len() {
                    if forest[y][index] >= forest[y][x] && index != x {
                        vis_right = false;
                    }
                }

                let mut vis_top: bool = true;
                for index in 0..y {
                    if forest[index][x] >= forest[y][x] && index != y {
                        vis_top = false;
                    }
                }

                let mut vis_bottom: bool = true;
                for index in y..forest.len() {
                    if forest[index][x] >= forest[y][x] && index != y {
                        vis_bottom = false;
                    }
                }

                visibilities[y][x] = vis_left || vis_right || vis_top || vis_bottom;
            }
        }
    }

    for line in visibilities {
        for tree in line {
            if tree {
                print!(".");
                visible_trees += 1;
            } else {
                print!(" ");
            }
        }
        println!();
    }

    println!("sum = {visible_trees}");
}
