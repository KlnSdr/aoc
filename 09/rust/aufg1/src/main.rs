use std::{fs, str::Lines};

const IS_TEST: bool = false;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST {".test"} else {""});
    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Lines = data.lines();
    let mut bridge: Vec<Vec<&str>> = vec![vec!["s"]];
    let mut head_pos: (usize, usize) = (0, 0); // (y, x)
    let mut tail_pos: (usize, usize) = (0, 0); // (y, x)

    print_grid(&bridge, &tail_pos, &head_pos);

    for line in data {
        let cmd: Vec<&str> = line.split_whitespace().collect();
        let steps: usize = cmd[1].parse::<usize>().unwrap();
        update_grid_and_pos(&mut bridge, &mut head_pos, &mut tail_pos, steps);
        for _i in 0..steps {
            match cmd[0] {
                "R" => {
                    println!("right => {}", steps);
                    head_pos.1 += 1;
                },
                "L" => {
                    println!("left => {}", steps);
                    println!("{}", head_pos.1);
                    head_pos.1 -= 1;
                },
                "U" => {
                    println!("up => {}", steps);
                    println!("{}", head_pos.0);
                    head_pos.0 -= 1;
                },
                "D" => {
                    println!("down => {}", steps);
                    head_pos.0 += 1;
                },
                _ => {
                    println!("well shit");
                }
            }
            if IS_TEST {
                println!("{}", is_touching(&head_pos, &tail_pos, &bridge));
            }

            if !is_touching(&head_pos, &tail_pos, &bridge) {
                if head_pos.0 > tail_pos.0 {
                    tail_pos.0 += 1;
                    println!("tail down");
                }

                if head_pos.0 < tail_pos.0 {
                    tail_pos.0 -= 1;
                    println!("tail up");
                }

                if head_pos.1 > tail_pos.1 {
                    tail_pos.1 += 1;
                    println!("tail right");
                }

                if head_pos.1 < tail_pos.1 {
                    tail_pos.1 -= 1;
                    println!("tail left");
                }
            }
            bridge[tail_pos.0][tail_pos.1] = "#";
            if IS_TEST {
                print_grid(&bridge, &tail_pos, &head_pos);
            }
        }
    }
    
    let mut tail_was_here_counter: u32 = 0;
    for line in bridge {
        for elm in line {
            if elm == "#" {
                tail_was_here_counter += 1;
            }
        }
    }

    println!("{tail_was_here_counter}");
}

fn update_grid_and_pos(grid: &mut Vec<Vec<&str>>, pos_head: &mut (usize, usize), pos_tail: &mut (usize, usize), step: usize) {
    if pos_head.0 + step >= grid.len() || pos_tail.0 + step >= grid.len() {
        for _i in 0..step {
            grid.push(vec!["."; grid[0].len()]);
        }
    }

    if pos_head.0 < step || pos_tail.0 < step {
        grid.reverse();
        for _i in 0..step {
            grid.push(vec!["."; grid[0].len()]);
        }
        pos_head.0 += step;
        pos_tail.0 += step;
        grid.reverse();
    }

    if pos_head.1 + step >= grid[0].len() || pos_tail.1 + step >= grid[0].len() {
        for line in &mut *grid {
            line.extend_from_slice(vec!["."; step].as_slice());
        }
    }

    if pos_head.1 < step || pos_tail.1 < step {
        for line in grid {
            line.reverse();
            line.extend_from_slice(vec!["."; step].as_slice());
            line.reverse();
        }
        println!("{}", pos_head.1);
        println!("{}", step);
        pos_head.1 += step;

        println!("{}", pos_tail.1);
        println!("{}", step);
        pos_tail.1 += step;
    }
}

fn print_grid(grid: &Vec<Vec<&str>>, tail_pos: &(usize, usize), head_pos: &(usize, usize)) {
    println!("+{}+", "-".repeat(grid[0].len()));
    for y in 0..grid.len() {
        print!("|");
        for x in 0..grid[y].len() {
            if &(y, x) == tail_pos {
                print!("T");
            } else if &(y, x) == head_pos {
                print!("H");
            } else {
                print!("{}", grid[y][x]);
            }
        }
        print!("|");
        println!();
    }
    println!("+{}+", "-".repeat(grid[0].len()));
}

fn is_touching(pos_head: &(usize, usize), pos_tail: &(usize, usize), grid: &Vec<Vec<&str>>) -> bool {
    if pos_tail == pos_head {
        return true;
    } else if pos_tail.0 > 0 && pos_tail.0 - 1 == pos_head.0 && pos_tail.1 == pos_head.1 {
        return true;
    } else if pos_tail.0 < grid.len() && pos_tail.0 + 1 == pos_head.0 && pos_tail.1 == pos_head.1 {
        return true;
    } else if pos_tail.1 > 0 && pos_tail.1 - 1 == pos_head.1 && pos_tail.0 == pos_head.0 {
        return true;
    } else if pos_tail.1 < grid[0].len() && pos_tail.1 + 1 == pos_head.1 && pos_tail.0 == pos_head.0 {
        return true;
    } else if pos_tail.0 > 0 && pos_tail.1 > 0 && &(pos_tail.0 - 1, pos_tail.1 - 1) == pos_head {
        return true;
    } else if pos_tail.0 > 0 && pos_tail.1 < grid[0].len() && &(pos_tail.0 - 1, pos_tail.1 + 1) == pos_head {
        return true;
    } else if pos_tail.0 < grid.len() && pos_tail.1 > 0 && &(pos_tail.0 + 1, pos_tail.1 - 1) == pos_head {
        return true;
    } else if pos_tail.0 < grid.len() && pos_tail.1 < grid[0].len() && &(pos_tail.0 + 1, pos_tail.1 + 1) == pos_head {
        return true;
    }
    return false;
}
