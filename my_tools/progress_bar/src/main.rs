use progress_bar::ProgressBar;

fn main() {
    let mut pb = ProgressBar::custom(5.0, 0.0, '[', '=', '>', ' ', ']', 7);
    loop {
        let p: f32 = input("Enter a number: ").parse().unwrap();
        pb.update(p).unwrap();
    }
}

fn input(prompt: &str) -> String {
    use std::io::{self, Write};
    let mut result = String::new();
    print!("{}", prompt);
    io::stdout().flush().unwrap();
    io::stdin()
        .read_line(&mut result)
        .expect("Failed to read the line");
    result.trim_end().to_string()
}
