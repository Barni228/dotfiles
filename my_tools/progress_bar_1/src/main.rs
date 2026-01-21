use std::{thread::sleep, time::Duration};

use progress_bar::ProgressBar;
fn main() {
    let mut pb = ProgressBar::new(10);
    for i in 0..15 {
        pb.inc().unwrap();
        sleep(Duration::from_millis(100));
        // println!("{:?}", pb);
        println!("{i}");
    }
}
