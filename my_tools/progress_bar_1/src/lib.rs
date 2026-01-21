// WARN: terminals don't allow you to remember a real, position, only a visible one, so this only works as long as you can see the progress bar
// when progress bar goes out of the screen, it will print itself on the top line, and erase whatever was there before
use std::{
    cmp::min,
    io::{Write, stderr},
    num::NonZeroUsize,
};

use crossterm::{execute, queue};

/// A ProgressBar object, used to create a progress bar
#[derive(Debug, Clone, PartialEq)]
pub struct ProgressBar {
    total: NonZeroUsize,
    current: usize,
    left_bracket: char,
    filled: char,
    tip: char,
    empty: char,
    right_bracket: char,
    length: i32,
    print_numbers: bool,
    pos: (u16, u16),
}

impl Default for ProgressBar {
    fn default() -> Self {
        Self::new(100)
    }
}

impl ProgressBar {
    /// create a new ProgressBar
    pub fn new(total: usize) -> Self {
        let total_non_zero = NonZeroUsize::new(total).expect("total must be greater than 0");
        Self::custom(total_non_zero, true, 0, '[', '=', '>', ' ', ']', 64)
    }

    /// Create a progress bar with fully custom settings.
    ///
    /// # Parameters
    /// - `total`: Total number of items (must be > 0)
    /// - `print_numbers`: Whether to print `current/total` after the bar
    /// - `current`: Initial progress value (clamped to `total`)
    /// - `left_bracket`: Character printed at the start of the bar
    /// - `filled`: Character used for completed progress
    /// - `tip`: Character shown at the current progress edge
    /// - `empty`: Character used for remaining space
    /// - `right_bracket`: Character printed at the end of the bar
    /// - `length`: Total bar length including brackets and tip
    pub fn custom(
        total: NonZeroUsize,
        print_numbers: bool,
        current: usize,
        left_bracket: char,
        filled: char,
        tip: char,
        empty: char,
        right_bracket: char,
        length: i32,
    ) -> Self {
        // save our cursor position
        let pos = crossterm::cursor::position().unwrap();
        execute!(stderr(), crossterm::cursor::SavePosition).unwrap();
        // go to new line, so no one prints at progress bar location (otherwise it will be erased)
        println!();

        let pb = Self {
            total,
            print_numbers,
            current,
            left_bracket,
            filled,
            tip,
            empty,
            right_bracket,
            length,
            pos,
        };
        pb.print().unwrap();
        pb
    }

    /// Update the progress bar to a new value
    /// this will set current to the new value, and print the progress bar
    /// if current is greater than total, it will be clamped (so current is always <= total)
    pub fn update(&mut self, current: usize) -> Result<(), std::io::Error> {
        self.current = min(current, self.total.get());

        self.print()
    }

    /// Increment the progress bar by 1
    /// Same as calling [ProgressBar::update] with `current + 1`
    pub fn inc(&mut self) -> Result<(), std::io::Error> {
        self.update(self.current + 1)
    }

    pub fn print(&self) -> Result<(), std::io::Error> {
        // queue
        queue!(
            stderr(),
            // crossterm::cursor::SavePosition,
            // crossterm::cursor::MoveTo(self.pos.0, self.pos.1),
            crossterm::cursor::RestorePosition,
            crossterm::terminal::Clear(crossterm::terminal::ClearType::CurrentLine),
        )?;

        // total is never zero, so no zero division errors
        let percent = self.current as f32 / self.total.get() as f32;
        // 2 chars for brackets, 1 for tip
        let inside_len = self.length - 3;
        print!(
            "{}{}{}{}{}",
            self.left_bracket,
            String::from(self.filled).repeat((inside_len as f32 * percent) as usize),
            match percent {
                0.0 => self.empty,
                1.0 => self.filled,
                _ => self.tip,
            },
            String::from(self.empty)
                .repeat(inside_len as usize - (inside_len as f32 * percent) as usize),
            self.right_bracket
        );

        if self.print_numbers {
            print!(" {}/{}", self.current, self.total)
        }

        println!();

        // queue!(stderr(), crossterm::cursor::RestorePosition)?;
        queue!(stderr(), crossterm::cursor::MoveDown(1000))?;

        stderr().flush()?;
        Ok(())
    }

    /// The total number of items
    #[must_use]
    pub fn total(&self) -> usize {
        self.total.get()
    }

    /// The current progression of the progress bar
    #[must_use]
    pub fn current(&self) -> usize {
        self.current
    }

    /// The total length of the progress bar, including all brackets and tip
    /// For example, if this equals to `4`, the progress bar will look something like
    /// ```txt
    /// [==> ]
    /// ```
    /// Note: this does not affect [ProgressBar::print_numbers]
    #[must_use]
    pub fn length(&self) -> i32 {
        self.length
    }

    /// If true, print the current and total after the progress bar
    /// So progress bar will look like
    /// ```txt
    /// [==> ] 10/10
    /// ```
    /// Note: [ProgressBar::length] does not affect this, so with `length = 4` and `print_numbers = true`, the progress bar will look like
    /// ```txt
    /// [==> ] 10/10
    /// ```
    #[must_use]
    pub fn print_numbers(&self) -> bool {
        self.print_numbers
    }

    #[must_use]
    pub fn left_bracket(&self) -> char {
        self.left_bracket
    }

    #[must_use]
    pub fn filled(&self) -> char {
        self.filled
    }

    #[must_use]
    pub fn tip(&self) -> char {
        self.tip
    }

    #[must_use]
    pub fn empty(&self) -> char {
        self.empty
    }

    #[must_use]
    pub fn right_bracket(&self) -> char {
        self.right_bracket
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_progress_bar() {
        let mut pb = ProgressBar::new(3);
        pb.inc().unwrap();
        pb.inc().unwrap();
        pb.inc().unwrap();
        pb.inc().unwrap();
    }
}
