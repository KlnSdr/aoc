use std::collections::HashMap;
use std::fs;
use std::str::{Lines, Split};
use std::borrow::Borrow;

#[derive(Debug, PartialEq)]
enum Operation {
    Mult,
    Div,
    Add,
    Sub,
}

#[derive(Debug, PartialEq)]
enum OperationValue {
    Fixed = 0,
    Dynamic = 1,
}

struct Test {
    value: i32,
    passed: String,
    failed: String,
}

struct Monkey {
    items: Vec<i32>,
    operation: (Operation, OperationValue, i32),
    test: Test,
}

const IS_TEST: bool = true;
fn main() {
    let file_name: String = format!("data{}.txt", if IS_TEST { ".test" } else { "" });
    let data: String = fs::read_to_string(file_name).expect("no file found");
    let data: Lines = data.lines();

    let mut monkeys: HashMap<&str, Monkey> = HashMap::new();
    let mut monkey_names: Vec<&str> = vec![];
    let mut current_monkey_name: &str = "";

    for line in data {
        if line.split("Monkey ").collect::<Vec<&str>>().len() > 1 {
            current_monkey_name = line.split("Monkey ").collect::<Vec<&str>>()[1]
                .split(":")
                .collect::<Vec<&str>>()[0];
            monkeys.insert(
                current_monkey_name,
                Monkey {
                    items: vec![],
                    operation: (Operation::Add, OperationValue::Fixed, 0),
                    test: Test {
                        value: 1,
                        passed: "".to_string(),
                        failed: "".to_string(),
                    },
                },
            );
            monkey_names.push(current_monkey_name);
        } else {
            let line: &str = line.trim();

            if line.split("Starting items: ").collect::<Vec<&str>>().len() > 1 {
                let items: &str = line.split("Starting items: ").collect::<Vec<&str>>()[1];
                let items: Split<&str> = items.split(", ");

                for i in items {
                    monkeys
                        .get_mut(current_monkey_name)
                        .expect(format!("no entry for this key: {}", current_monkey_name).borrow())
                        .items
                        .push(i.parse::<i32>().unwrap());
                }
            } else if line
                .split("Operation: new = old ")
                .collect::<Vec<&str>>()
                .len()
                > 1
            {
                let op: Vec<&str> = line.split("Operation: new = old ").collect::<Vec<&str>>();
                let op: (&str, &str) = op[1].split_at(1);
                let math_op: &str = op.0;
                let op_value: &str = op.1.trim();

                let mut op: (Operation, OperationValue, i32) =
                    (Operation::Add, OperationValue::Fixed, 0);

                if op_value == "old" {
                    op.1 = OperationValue::Dynamic;
                } else {
                    op.2 = op_value.parse::<i32>().unwrap();
                }

                match math_op {
                    "+" => op.0 = Operation::Add,
                    "-" => op.0 = Operation::Sub,
                    "*" => op.0 = Operation::Mult,
                    "/" => op.0 = Operation::Div,
                    _ => (),
                };

                monkeys
                    .get_mut(current_monkey_name)
                    .expect(format!("no entry for this key: {}", current_monkey_name).borrow())
                    .operation = op;
            } else if line.split("Test:").collect::<Vec<&str>>().len() > 1 {
                let test: Vec<&str> = line.split("Test: divisible by ").collect::<Vec<&str>>();
                monkeys
                    .get_mut(current_monkey_name)
                    .expect(format!("no entry for this key: {}", current_monkey_name).borrow())
                    .test
                    .value = test[1].parse::<i32>().unwrap();
            } else if line.split("If true:").collect::<Vec<&str>>().len() > 1 {
                let action: Vec<&str> = line
                    .split("If true: throw to monkey ")
                    .collect::<Vec<&str>>();
                monkeys
                    .get_mut(current_monkey_name)
                    .expect(format!("no entry for this key: {}", current_monkey_name).borrow())
                    .test
                    .passed = action[1].to_string();
            } else if line.split("If false:").collect::<Vec<&str>>().len() > 1 {
                let action: Vec<&str> = line
                    .split("If false: throw to monkey ")
                    .collect::<Vec<&str>>();
                monkeys
                    .get_mut(current_monkey_name)
                    .expect(format!("no entry for this key: {}", current_monkey_name).borrow())
                    .test
                    .failed = action[1].to_string();
            }
        }
    }

    // TODO / FIXME borrow stuff mit annoations
    for name in monkey_names {
        let monkey: &Monkey = monkeys
            .get_mut(name)
            .expect(format!("no entry in HashMap with id '{}'", name).borrow());

        for item in &monkey.items {
            let mut worry_level: i32 = item.to_owned();
            let the_other_value_thingy: i32;

            match monkey.operation.1 {
                OperationValue::Fixed => the_other_value_thingy = monkey.operation.2,
                OperationValue::Dynamic => the_other_value_thingy = worry_level,
            }
            match monkey.operation.0 {
                Operation::Add => worry_level += the_other_value_thingy,
                Operation::Sub => worry_level -= the_other_value_thingy,
                Operation::Mult => worry_level *= the_other_value_thingy,
                Operation::Div => worry_level /= the_other_value_thingy,
            }

            if (worry_level / 3) % monkey.test.value == 0 {
                let first_item: &i32 = monkey.items.first().unwrap();
                let target_monkey: &String = &monkey.test.passed;
                &monkey.items.to_owned().reverse();
                &monkey.items.to_owned().pop();
                &monkey.items.to_owned().reverse();
                monkeys.get_mut(&monkey.test.passed.borrow()).expect("").items.push(first_item.to_owned());
            } else {
                let mut itms: &Vec<i32> = &monkey.items;
                itms.reverse();
                let pop_item: i32 = itms.pop().expect("well fuck");
                monkeys
                    .get_mut::<str>(monkey.test.failed.borrow())
                    .expect(
                        format!(
                            "no entry in HashMap with id '{}'",
                            monkey.test.failed.borrow() as &str
                        )
                        .borrow(),
                    )
                    .items
                    .push(pop_item);
                itms.reverse();
            }
        }
    }
    print_hashmap(&monkeys);
}

fn print_hashmap(hp: &HashMap<&str, Monkey>) {
    for (key, value) in hp.into_iter() {
        println!("monkey {}", key.to_owned());
        println!("\titems:");
        for item in &value.items {
            println!("\t\t{item}");
        }
        println!("\toperation:");
        println!("\t\t{:?}", value.operation.0);
        if value.operation.1 == OperationValue::Fixed {
            println!("\t\t{}", value.operation.2);
        } else {
            println!("\t\told");
        }
        println!("\ttest: divisible by {}", value.test.value);
        println!("\t\ttrue => {}", value.test.passed);
        println!("\t\tfalse => {}", value.test.failed);
    }
}
