use std::fs;

const IS_TEST: bool = false;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST {".test"} else {""});
    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Vec<&str> = data.lines().collect();

    let mut register: i32 = 1;

    let mut index: usize = 0;
    let mut cmd_stack: Vec<&str> = vec![];

    let mut beam: (i32, i32) = (-1, 0); // (x, y)

    while index < data.len() {
        beam.0 += 1;

        // draw
        if register == beam.0 || register + 1 == beam.0 || register - 1 == beam.0 {
            print!("*");
        } else {
            print!(" ");
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

        // execute current command
        if cmd != "noop" {
            let value: Vec<&str> = cmd.split("addx ").collect();
            let value: i32 = value[1].parse::<i32>().unwrap();

            register += value;
        }
        
        if beam.0 >= 39 {
            beam.0 = -1;
            beam.1 += 1;
            println!();
        }
    }

}
