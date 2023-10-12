use std::fs;
use std::str::{Lines, SplitWhitespace};

fn main() {
    const IS_TEST: bool = false;
    let file_path: String = format!("data.{}txt", if IS_TEST {"test."} else { "" });
    let data: String = fs::read_to_string(file_path).expect("no file mister");
    let data: Lines = data.lines();

    let mut crates: Vec<&str> = vec![];
    let mut commands: Vec<&str> = vec![];
    
    let mut at_crates: bool = true;

    for line in data {
        if at_crates {
            if line == "" {
                at_crates = false;
                continue;
            }

            crates.push(line);
        } else {
            commands.push(line);
        }
    }

    let mut all_crates: Vec<Vec<String>> = vec![];

    for _i in 0..(crates[crates.len() - 1].len() + 1)/4 {
        all_crates.push(vec![]);
    }

    let mut tmp: String = String::from("");
    let mut skip: bool = false;
    let mut offset: u8 = 0;
    
    let mut crate_index: usize = 0;
    
    // remove last line
    crates.pop();
    // reverse so stacks are generated from bottom to top
    crates.reverse();

    for line in crates {
        for (index, value) in line.chars().enumerate() {
            if skip {
                skip = false;
                continue;
            }

            tmp.push(value);
            if (index + 1 - offset as usize) % 3 == 0 {
                if tmp.starts_with("[") {
                    all_crates[crate_index].push(tmp.clone());
                }
                skip = true;
                offset += 1;
                tmp = String::from("");
                crate_index += 1;
            }
        }

        offset = 0;
        skip = false;
        crate_index = 0;
    }
    // generating stacks done
    // ==========================================================
    
    for cmd in commands {
        // let cmd: &str = cmd.split_at(5).1;
        let cmd: SplitWhitespace = cmd.split_whitespace();
        
        let mut cmd_arr: [u8; 3] = [0, 0, 0];
        for (index, value) in cmd.enumerate() {
            if index % 2 == 1 {
                cmd_arr[(index - 1) / 2] = value.parse::<u8>().unwrap() - 1;
            }
        }
        cmd_arr[0] += 1;

        if IS_TEST {
            print_2d_vec(&all_crates);
        }
        
        let mut tmp_vec: Vec<String> = vec![];
        for _i in 0..cmd_arr[0] {
            let crate_tmp: String = all_crates[cmd_arr[1] as usize].pop().unwrap();
            tmp_vec.push(crate_tmp);
        }

        tmp_vec.reverse();

        for current_crate in tmp_vec {
            all_crates[cmd_arr[2] as usize].push(current_crate);
        }

        if IS_TEST {
            println!("===");
        }
    }
    if IS_TEST {
        print_2d_vec(&all_crates);
        println!("===");
    }
    // moving crates done
    // ==========================================================
    let mut output: Vec<String> = vec![];

    for mut stack in all_crates { 
        let crate_tmp: String = stack.pop().unwrap();
        output.push(crate_tmp);
    }
    
    for i in output {
        let b: u8 = i.as_bytes()[1];
        let c: char = b as char;
        print!("{c}");
    }
}

fn print_2d_vec(vector: &Vec<Vec<String>>) {
    for stack in vector {
        for elm in stack {
            print!("{elm}");
        }
        println!();
    }
}
