#[cfg(feature = "napi")]
use napi_derive::napi;

#[cfg(feature = "napi")]
#[napi]
pub async fn convert_svg_to_react(
    svg_content: String,
    component_name: String,
    is_javascript: bool,
    destination_folder: String,
) -> napi::Result<String> {
    use std::path::PathBuf;
    use crate::convert::SvgToReact;
    use crate::default::Config;

    let config = Config {
        is_javascript,
        destination_folder: PathBuf::from(destination_folder),
    };

    let converter = SvgToReact::new(svg_content, component_name, config);
    
    match converter.convert_and_save() {
        Ok(path) => Ok(format!("{:?}", path)),
        Err(e) => Err(napi::Error::from_reason(e.to_string())),
    }
}

#[cfg(feature = "napi")]
#[napi]
pub fn validate_svg(content: String) -> bool {
    use regex::Regex;
    let re = Regex::new(r"(?s)<svg[^>]*>.*?</svg>").unwrap();
    re.is_match(&content)
}

// Re-export modules for binary usage
pub mod args;
pub mod parser;
pub mod asset;
pub mod content;
pub mod convert;
pub mod default;