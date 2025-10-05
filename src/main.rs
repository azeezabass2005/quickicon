use clap::Parser;
use dialoguer::console::style;
use asset::{QUICK_ICON};
use args::Args;

use crate::{convert::SvgToReact};

mod args;
mod parser;
mod asset;
mod content;
mod convert;
mod default;

#[tokio::main]
async fn main() {
    println!("{}", style(QUICK_ICON).blue());

    let args = Args::parse();
    let config = default::get_and_save_config(&args).unwrap();

    match content::get_content(&args).await {
        Ok(content) => {            
            match SvgToReact::new(content, args.icon_name, config).convert_and_save() {
                Ok(path) => {
                    let msg = style(format!("🎉 Your icon has been generated and you can find it in: {:?}", path)).green();
                    println!("{}", msg);
                },
                Err(err) => {
                    println!("An error occurred when generating the component: {}", style(err).red());
                }
            }
        },
        Err(err_message) => {
            println!("An error occurred while reading content: {}", style(err_message).red());
        }
    }
}
