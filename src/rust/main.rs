use std::{
    env,
    fs::{metadata, read_to_string},
    io::{stdin, BufRead, BufReader, IsTerminal},
    process::exit,
};

const INPUT_TABLE: &str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
const OUTPUT_TABLE: &str = "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm";

fn rot13(input: String) -> String {
    let mut string = String::new();
    for ch in input.chars() {
        let mut c = ch;
        for (i, t) in INPUT_TABLE.chars().enumerate() {
            if ch == t {
                c = OUTPUT_TABLE.chars().nth(i).expect("");
            }
        }
        string.push(c);
    }
    string
}

fn usage() {
    eprint!("Usage: rot13: [options] [files]\n options: -h, --help: Print this help message\n");
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let arg_len = args.len();
    for arg in &args {
        if arg == "-h" || arg == "--help" {
            usage();
            exit(1);
        }
    }

    if arg_len >= 1 {
        if !stdin().is_terminal() {
            let reader = BufReader::new(stdin().lock());
            let mut string = String::new();
            for line in reader.lines() {
                string += &(line.unwrap() + "\n")
            }
            print!("{}", rot13(string));
            exit(0);
        }
    }

    for i in 1..arg_len {
        let arg = &args[i];
        if metadata(arg.clone()).unwrap().is_dir() {
            eprint!("rot: {}: Permission denied", arg);
            continue;
        }
        match read_to_string(arg.clone()) {
            Ok(content) => {
                print!("{}", rot13(content));
            }
            Err(_) => {
                eprintln!("rot: couldn't read file: {}", arg);
                continue;
            }
        }
    }

    if arg_len <= 1 {
        usage();
        exit(1)
    }
}
