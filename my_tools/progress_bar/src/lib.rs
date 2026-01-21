use std::io::{Write, stdout};

use crossterm::execute;

pub struct ProgressBar {
    pub total: f32,
    pub current: f32,
    pub left_bracket: char,
    pub filled: char,
    pub tip: char,
    pub empty: char,
    pub right_bracket: char,
    pub length: i32,
}

impl ProgressBar {
    pub fn new(total: f32) -> Self {
        execute!(stdout(), crossterm::cursor::SavePosition).unwrap();
        Self {
            total,
            current: 0.0,
            left_bracket: '[',
            filled: '=',
            tip: '>',
            empty: ' ',
            right_bracket: ']',
            length: 50,
        }
    }

    pub fn custom(
        total: f32,
        current: f32,
        left_bracket: char,
        filled: char,
        tip: char,
        empty: char,
        right_bracket: char,
        length: i32,
    ) -> Self {
        execute!(stdout(), crossterm::cursor::SavePosition).unwrap();
        Self {
            total,
            current,
            left_bracket,
            filled,
            tip,
            empty,
            right_bracket,
            length,
        }
    }

    pub fn update(&mut self, current: f32) -> Result<(), std::io::Error> {
        self.current = current;

        let capped_current = match self.current > self.total {
            true => self.total,
            false => self.current,
        };

        execute!(
            stdout(),
            crossterm::cursor::RestorePosition,
            crossterm::terminal::Clear(crossterm::terminal::ClearType::CurrentLine),
        )?;
        let percent = capped_current as f32 / self.total as f32;
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

        stdout().flush()?;
        Ok(())
    }

    pub fn inc(&mut self) -> Result<(), std::io::Error> {
        self.update(self.current + 1.0)
    }
}
