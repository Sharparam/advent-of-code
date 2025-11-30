use std::io::{self, Read};

/// Input data container for AoC problems.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Input {
    /// The raw input data as a string.
    data: String,
}

impl Input {
    pub fn new(data: String) -> Self {
        Self { data }
    }

    pub fn from_stdin() -> Self {
        let mut buffer = String::new();
        io::stdin()
            .read_to_string(&mut buffer)
            .expect("Failed to read from stdin");

        Self::new(buffer)
    }

    pub fn from_file(path: &std::path::Path) -> Self {
        let data = std::fs::read_to_string(path).expect("Failed to read input file");
        Self::new(data)
    }

    pub fn as_str(&self) -> &str {
        &self.data
    }

    pub fn len(&self) -> usize {
        self.data.len()
    }

    pub fn is_empty(&self) -> bool {
        self.data.is_empty()
    }
}

impl From<&str> for Input {
    fn from(s: &str) -> Self {
        Self::new(s.to_string())
    }
}

impl From<String> for Input {
    fn from(s: String) -> Self {
        Self::new(s)
    }
}

impl std::fmt::Display for Input {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.data)
    }
}
