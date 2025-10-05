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
                println!("This is the body from the icon fetched: {:?}", tag);
                match tag {
                    None => {
                        return Err("There is no svg returned from the provided url".into());
                    },
                    Some(svg_tag) => {
                        let content = svg_tag[0].to_string();
                        println!("This is the tag from regex: {}", content);
                        return Ok(svg_tag[0].to_string());
                    }
                }
            } else {
                let path = PathBuf::try_from(path).unwrap();
                println!("this is the path {:?}, {}, {}", &args.path, path.ends_with(".svg"), path.ends_with(".txt"));
                
                if let Some(extension) = path.extension() {
                    println!("The file extension is {:?}", &extension);
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
