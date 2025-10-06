use std::{fs, path::PathBuf};
use crate::{args::Args, parser::svg_validator};
use arboard::Clipboard;
use regex::Regex;

pub async fn get_content(args: &Args) -> Result<String, Box<dyn std::error::Error>> {
    match &args.path {
        Some(path) => {
            // What I want to do here is read the file or read the url

            if path.starts_with("https://") || path.starts_with("www.") {
                let response = reqwest::get(path).await?;
                let body = response.text().await?;

                let pattern = r#"(?s)<svg[^>]*>.*?</svg>"#;

                let re = Regex::new(pattern)?;
                let tag = re.captures(&body);
                match tag {
                    None => {
                        return Err("There is no svg returned from the provided url".into());
                    },
                    Some(svg_tag) => {
                        return Ok(svg_tag[0].to_string());
                    }
                }
            } else {
                let path = PathBuf::try_from(path).unwrap();
                
                if let Some(extension) = path.extension() {
                    if extension == "svg" || extension == "txt" {
                        match fs::read_to_string(path) {
                            Ok(content) => {
                                if svg_validator(&content) {
                                    Ok(content)
                                } else {
                                    Err("The file you provided does not contain a valid svg element.".into())
                                }
                            },
                            Err(_err) => {
                                Err("An error occurred while reading the provided svg file".into())
                            }
                        }    
                    } else {
                        Err("Only .svg or .txt files are allowed".into())
                    }
                } else {
                    Err("File has no extension and only .svg or .txt files are allowed".into())
                }
            }
        }, 
        None => {
            let mut clipboard = Clipboard::new().unwrap();
            let clipboard_text_content = clipboard.get_text().unwrap();
            if svg_validator(&clipboard_text_content) {
                Ok(clipboard_text_content)
            } else {
                Err("Your clipboard text content is not a valid svg.".into())
            }
            
        }
    }
}
