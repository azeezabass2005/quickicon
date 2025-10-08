use std::{path::PathBuf};

use regex::Regex;

/// Parses the directory where the icon is to be stored
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

/// Checks if the size is actually a valid value
pub fn size_parser(s: &str) -> Result<u32, String> {
    let num = s.parse::<u32>();
    match num {
        Ok(num) => {
            if num > 0 {
                return Ok(num);
            } else {
                return Err("The size of the icon cannot be 0".to_string());
            }
        },
        Err(_) => {
            return Err("Please enter a valid number greater than 0 for the size".to_string())
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
