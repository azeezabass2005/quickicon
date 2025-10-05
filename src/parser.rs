use std::{io::Cursor, path::PathBuf};

use regex::Regex;

pub fn directory_parser(s: &str) -> Result<String, String> {
    match PathBuf::try_from(s) {
        Ok(_path) => {
            Ok(s.to_string())
        },
        Err(_) => {
            Err("Invalid icon destination".to_string())
        }
    }
}

/// Checks if a string is actually an svg
pub fn svg_validator(s: &str) -> bool {
    let pattern = r#"(?s)<svg[^>]*>.*?</svg>"#;
    let re = Regex::new(pattern).unwrap();
    let tag = re.captures(&s);
    match tag {
        None => false,
        Some(_) => true
    }
}
