use std::{fs, path::PathBuf};

use crate::args::Args;
use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Serialize, Deserialize, Debug)]
pub struct Config {
    pub is_javascript: bool,
    pub destination_folder: PathBuf,
}

/// Get the config if it's not provided and saves it as default if specified in the argument
pub fn get_and_save_config(args: &Args) -> Result<Config, Box<dyn std::error::Error>> {
    let config_file_path = PathBuf::from("./quickicon.json");
    let default_destination = PathBuf::from("./public/assets/icon");
    
    let mut config = if config_file_path.exists() {
        serde_json::from_str(&fs::read_to_string(&config_file_path)?).unwrap_or_else(|_| Config {
            is_javascript: false,
            destination_folder: default_destination,
        })
    } else {
        Config {
            is_javascript: false,
            destination_folder: default_destination,
        }
    };
    
    if let Some(dest) = &args.destination {
        config.destination_folder = PathBuf::from(dest);
    }

    if let Some(lang) = &args.language {
        config.is_javascript = lang == "javascript";
    }
    
    if args.default {
        save_config(&config_file_path, &config)?;
    }
    
    Ok(config)
}

fn save_config(path: &PathBuf, config: &Config) -> Result<(), Box<dyn std::error::Error>> {
    let json_config = serde_json::to_string(config)?;
    fs::write(path, json_config)?;
    Ok(())
}