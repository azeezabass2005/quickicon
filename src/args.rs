use clap::{Parser};
use crate::parser::{directory_parser};

#[derive(Parser, PartialEq, Debug)]
pub struct Args {

    /// The programming language if it is JavaScript (default language is Typescript)
    #[arg(long, action = clap::ArgAction::SetTrue)]
    #[arg(long = "no-javascript", action = clap::ArgAction::SetFalse)]
    pub javascript: Option<bool>,

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