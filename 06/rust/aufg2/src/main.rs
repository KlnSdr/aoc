use std::fs;

const IS_TEST: bool = false;
fn main() {
    let file_path: String = format!("data{}.txt", if IS_TEST {".test"} else {""});

    let data: String = fs::read_to_string(file_path).expect("gib halt eine vorhandene datei an du depp");

    let mut buffer: Vec<char> = vec![];
    let mut index: usize = 0;

    for chr in data.chars() {
        let mut all_different: bool = false;
        buffer.push(chr);

        if buffer.len() > 14 {
            all_different = true;
            buffer.remove(0);
            for elm in &buffer {
                if buffer.iter().filter(|&n| *n == elm.to_owned()).count() > 1 {
                    all_different = false;
                    break;
                }
            }
        }
        index += 1;

        if all_different {
            break;
        }
    }

    println!("{index}");
}
