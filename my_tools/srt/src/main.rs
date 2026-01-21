use std::{
    fs::File,
    io::{BufRead, BufReader, Write},
    path::PathBuf,
};

use clap::{arg, command, value_parser};
use lazy_regex::{regex, regex_is_match};

// TODO: make <PATH> optional, and read from stdin if not set
// anyhow allows to use `?` with any error, and it prints them nicely
fn main() -> anyhow::Result<()> {
    let args = command!()
        .args([
            arg!(<PATH> "Path to srt file").value_parser(value_parser!(PathBuf)),
            arg!(-o --output <PATH> "Output file, will modify original if this is not set")
                .value_parser(value_parser!(PathBuf)),
        ])
        .get_matches();

    let path = args.get_one::<PathBuf>("PATH").unwrap();
    // let content = std::fs::read_to_string(path)?;
    let mut subs: Vec<String> = vec![];

    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let mut current: Vec<String> = vec![];

    for line in reader.lines() {
        let line = line?.trim_end().to_owned();
        // this will fix the problems with BOM (encoding stuff)
        let line = line.replace('\u{FEFF}', "");

        if line.is_empty() {
            if !current.is_empty() {
                subs.push(current.join("\n"));
                current = vec![];
            }
            continue;
        }

        // if we have not started making a new subtitle
        if current.is_empty() {
            let time_stamp = regex!(r"^\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}$");
            // if it is index, ignore it
            if regex_is_match!(r"^\d+$", &line.trim()) {
                continue;
            // if it is not a time stamp, then add this to the last subtitle
            } else if !time_stamp.is_match(&line.trim()) {
                let last = subs.last_mut();
                // if there is no last subtitle, then we don't continue so it will be treated as a new subtitle
                if let Some(last) = last {
                    last.push_str(&format!("\n{line}"));
                    continue;
                }
            }
        }

        current.push(line);
    }

    if !current.is_empty() {
        subs.push(current.join("\n"));
    }

    let mut out_file = match args.get_one::<PathBuf>("output") {
        Some(out) => File::create_new(out)?,
        None => File::create(path)?,
    };

    let content = subs
        .iter()
        .enumerate()
        .map(|(i, sub)| format!("{}\n{}", i + 1, sub))
        .collect::<Vec<_>>()
        .join("\n\n");

    out_file.write_all(content.as_bytes())?;

    write!(out_file, "\n")?;

    Ok(())
}
