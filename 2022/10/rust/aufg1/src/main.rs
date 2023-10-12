use std::fs;

const IS_TEST: bool = false;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST {".test"} else {""});
    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Vec<&str> = data.lines().collect();

    let mut register: i32 = 1;

    let mut index: usize = 0;
    let mut cycle: u32 = 0;
    let mut special_cycle: u32 = 20;
    let mut cmd_stack: Vec<&str> = vec![];

    let mut sum_signal_strengths: i32 = 0;

    while index < data.len() {
        cycle += 1;
        if cycle == special_cycle {
            sum_signal_strengths += register * cycle as i32;
            special_cycle += 40;
        }

        let mut cmd: &str;
        
        // get command to execute in this cycle
        if cmd_stack.len() > 0 {
            cmd = cmd_stack.pop().unwrap();
            index += 1;
        } else {
            cmd = data[index];
            if cmd != "noop" {
                cmd_stack.push(cmd);
                cmd = "noop";
            } else {
                index += 1;
            }
        }

        if IS_TEST {
            println!("{cmd}");
        }
        // execute current command
        if cmd != "noop" {
            let value: Vec<&str> = cmd.split("addx ").collect();
            let value: i32 = value[1].parse::<i32>().unwrap();

            register += value;
        }
        
        if IS_TEST {
            println!("{cycle} => {register}");
        }
    }

    println!("{sum_signal_strengths}");
}
