use std::fs;

use assert_cmd::Command;

fn run(args: impl IntoIterator<Item = impl AsRef<std::ffi::OsStr>>) -> String {
    let output = Command::cargo_bin("srt")
        .unwrap()
        .args(args)
        .output()
        .unwrap();

    assert!(output.status.success());

    String::from_utf8(output.stdout).unwrap()
}

fn test(path: &str) {
    let path = format!("_t/{}", path);
    run([&path]);
    assert_eq!(
        fs::read_to_string(&path).unwrap(),
        fs::read_to_string(&path.replace(".srt", "_result.srt")).unwrap()
    );
}

#[test]
fn test_empty_file() {
    test("empty.srt");
}

#[test]
fn test_start_0() {
    test("start_0.srt");
}

#[test]
fn test_normal() {
    test("normal.srt");
}

#[test]
fn test_deleted() {
    test("deleted.srt");
}

#[test]
fn test_added() {
    test("added.srt");
}

#[test]
fn test_missing_lines() {
    test("missing_lines.srt");
}

#[test]
fn test_ugly() {
    test("ugly.srt");
}

#[test]
fn test_extra_new_line() {
    test("extra_new_line.srt");
}

#[test]
fn test_many() {
    test("many.srt");
}
