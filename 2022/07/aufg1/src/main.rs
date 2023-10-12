use std::fs;
use std::str::Lines;
use std::collections::HashMap;

const IS_TEST: bool = false;
const DEBUG: bool = false;
fn main() {
    let mut sum_of_smaller_folders: u32 = 0;

    let file_name: String = format!("data{}.txt", if IS_TEST {".test"} else {""});

    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Lines = data.lines();

    let mut tabs: u8 = 0;

    let mut file_system: HashMap<&str, (u32, Vec<&str>)> = HashMap::new();
    let mut cwd: &str = "";
    let mut cwd_history: Vec<&str> = vec![];

    for line in data {
        if line == "$ ls" {
            continue;
        }

        let split_at_cd: Vec<&str> = line.split("$ cd ").collect();
        if split_at_cd.len() > 1 {
            tabs += 1;

            if split_at_cd[1] == ".." {
                for (key, value) in file_system.iter() {
                    if value.1.contains(&cwd) {
                        cwd = key;
                        break;
                    }
                }
                tabs -= 2;
            } else {
                cwd = split_at_cd[1];

//                if !file_system.contains_key(cwd) {
                    cwd_history.push(cwd);
                    file_system.insert(cwd, (0, vec![]));
//                }
                
                if IS_TEST || DEBUG {
                    println!("{}{} (dir)", indent(tabs), split_at_cd[1]);
                }
            }
        } else if line.contains("dir ") {
            let split_dir: Vec<&str> = line.split("dir ").collect();
            file_system.get_mut(cwd).expect("no key in HashMap").1.push(split_dir[1]);
        } else {
            let split_file: Vec<&str> = line.split(" ").collect();

            if IS_TEST || DEBUG {
                println!("{}- {} (file, size={})", indent(tabs), split_file[1], split_file[0]);
            }

            file_system.get_mut(cwd).expect("key not in HashMap").0 += split_file[0].parse::<u32>().unwrap();
        }
    }

    for key in cwd_history {
        let value: &(u32, Vec<&str>) = file_system.get(key).expect("key not in HashMap");
        let folder_size: u32 = calc_folder_size(&file_system, key);

        if IS_TEST || DEBUG {
            println!("{key} ===");
            println!("\tsize: {}", folder_size);
            println!("\tsubfolders: [");
            for sub in value.1.to_owned() {
                println!("\t\t- {sub}");
            }
            println!("\t\t]");
        }

        if folder_size <= 100000 {
            sum_of_smaller_folders += folder_size;
        }
    }

    println!("{sum_of_smaller_folders}");
}

fn indent(n: u8) -> String {
    let mut tabs: String = "".to_owned();
    
    for _i in 0..n {
        tabs += "\t";
    }
    return tabs;
}

fn calc_folder_size(hashmap: &HashMap<&str, (u32, Vec<&str>)>, current_dir: &str) -> u32 {
    let current_dir_data: &(u32, Vec<&str>) = hashmap.get(current_dir).expect("key not in hashmap");
    let mut folder_size: u32 = current_dir_data.0;

    for sub_folder in &current_dir_data.1 {
        folder_size += calc_folder_size(hashmap, sub_folder);
    }

    return folder_size;
}
