pub struct Subtitles {
    pub subtitles: Vec<String>,
}

impl From<String> for Subtitles {
    fn from(s: String) -> Subtitles {
        Subtitles { subtitles: vec![s] }
    }
}

pub fn delete(index: usize, subtitles: &mut Vec<String>) {
    subtitles.remove(index);
}
