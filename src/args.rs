use clap::{Parser};
use crate::parser::{directory_parser};

#[derive(Parser, PartialEq, Debug)]
#[command(version)]
pub struct Args {
    /// Use JavaScript instead of TypeScript (use --language=typescript to switch back)
    #[arg(long, short, value_name = "LANG", value_parser = ["typescript", "javascript"])]
    pub language: Option<String>,

    /// The name of the react component for the icon e.g EyeIcon
    #[arg(
        long,
        short,
    )]
    pub icon_name: String,

    /// The path to the file on your computer or the online url
    #[arg(
        long,
        short,
    )]
    pub path: Option<String>,

    /// The destination folder of the icon
    #[arg(
        long,
        short,
        value_parser = directory_parser
    )]
    pub destination: Option<String>,

    /// Remember the folder destination and the language for subsequent icons
    #[arg(
        long,
        short = 'D'
    )]
    pub default: bool,
}