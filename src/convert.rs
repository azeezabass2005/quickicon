use std::{collections::HashMap, fs, path::PathBuf};

use regex::Regex;

use crate::default::Config;

pub struct SvgToReact {
    svg_string: String,
    component_name: String,
    config: Config,
}

impl SvgToReact {
    pub fn new(svg_string: String, component_name: String, config: Config) -> Self {
        SvgToReact { svg_string, component_name, config }
    }
    
    /// Processes the svg, generates the component and save the component to a file
    pub fn convert_and_save(&self) -> Result<PathBuf, Box<dyn std::error::Error>> {
        self.check_component_existence()?;
        let processed_svg = self.process_svg()?;
        let component = self.wrap_in_component(&processed_svg);
        let path = self.save_to_file(&component)?;
        Ok(path)
    }
    
    /// Convert attributes, extract colors and dimensions
    fn process_svg(&self) -> Result<String, Box<dyn std::error::Error>> {
        let mut svg = self.svg_string.clone();

        svg = self.convert_attributes(&svg);
        svg = self.convert_inline_styles(&svg);
        svg = self.replace_dimensions(&svg);
        svg = self.replace_colors(&svg);
        svg = self.spread_props(&svg);

        Ok(svg)

    }

    /// Converts all the hyphenated attributes to camelCase
    fn convert_attributes(&self, svg: &str) -> String {
        let attributes_map = self.get_attributes();
        let mut result = svg.to_string();
        for (html_attr, xml_attr) in attributes_map.iter() {
            let pattern = format!(r#"{}="#, html_attr);
            let re = Regex::new(&pattern).unwrap();
            result = re.replace_all(&result, format!(r#"{}="#, xml_attr)).to_string();
        }
        result
    }

    /// Returns all the mapping of HTML Attributes to XML Attributes
    fn get_attributes(&self) -> HashMap<&str, &str> {
        let mut map = HashMap::new();
        map.insert("fill-rule", "fillRule");
        map.insert("clip-rule", "clipRule");
        map.insert("stroke-width", "strokeWidth");
        map.insert("stroke-linecap", "strokeLinecap");
        map.insert("stroke-linejoin", "strokeLinejoin");
        map.insert("stroke-dasharray", "strokeDasharray");
        map.insert("stroke-dashoffset", "strokeDashoffset");
        map.insert("stroke-miterlimit", "strokeMiterlimit");
        map.insert("stroke-opacity", "strokeOpacity");
        map.insert("fill-opacity", "fillOpacity");
        map.insert("stop-color", "stopColor");
        map.insert("stop-opacity", "stopOpacity");
        map.insert("marker-start", "markerStart");
        map.insert("marker-mid", "markerMid");
        map.insert("marker-end", "markerEnd");
        map.insert("clip-path", "clipPath");
        map.insert("color-interpolation", "colorInterpolation");
        map.insert("color-interpolation-filters", "colorInterpolationFilters");
        map.insert("flood-color", "floodColor");
        map.insert("flood-opacity", "floodOpacity");
        map.insert("lighting-color", "lightingColor");
        map.insert("mask-type", "maskType");
        map.insert("text-anchor", "textAnchor");
        map.insert("text-decoration", "textDecoration");
        map.insert("text-rendering", "textRendering");
        map.insert("vector-effect", "vectorEffect");
        map.insert("writing-mode", "writingMode");
        map.insert("font-family", "fontFamily");
        map.insert("font-size", "fontSize");
        map.insert("font-weight", "fontWeight");
        map.insert("font-style", "fontStyle");
        map.insert("font-variant", "fontVariant");
        map.insert("font-stretch", "fontStretch");
        map.insert("dominant-baseline", "dominantBaseline");
        map.insert("alignment-baseline", "alignmentBaseline");
        map.insert("baseline-shift", "baselineShift");
        map.insert("shape-rendering", "shapeRendering");
        map.insert("color-profile", "colorProfile");
        map.insert("enable-background", "enableBackground");
        map.insert("glyph-orientation-horizontal", "glyphOrientationHorizontal");
        map.insert("glyph-orientation-vertical", "glyphOrientationVertical");
        map.insert("kerning", "kerning");
        map.insert("letter-spacing", "letterSpacing");
        map.insert("word-spacing", "wordSpacing");
        map.insert("xml:lang", "xmlLang");
        map.insert("xml:space", "xmlSpace");
        map.insert("xmlns:xlink", "xmlnsXlink");
        map.insert("xlink:href", "xlinkHref");
        map.insert("xlink:show", "xlinkShow");
        map.insert("xlink:actuate", "xlinkActuate");
        map.insert("xlink:type", "xlinkType");
        map.insert("xlink:role", "xlinkRole");
        map.insert("xlink:title", "xlinkTitle");
        map.insert("class", "className");

        map

    }

    /// Converts the inline styles from html format to react double bracket format
    fn convert_inline_styles(&self, svg: &str) -> String {
        let re = Regex::new(r#"style="([^"]*)""#).unwrap();
        re.replace_all(svg, |caps: &regex::Captures| {
            let style_string = &caps[1];
            let style_object = self.parse_style_to_object(&style_string);
            format!("style={{{{ {} }}}}", style_object)
        }).to_string()
    }

    fn parse_style_to_object(&self, style_string: &str) -> String {   
        style_string
            .split(";")
            .filter(|s| !s.trim().is_empty())
            .map(|property| {
                let parts: Vec<&str> = property.split(":").collect();
                if parts.len() == 2 {
                    let key = self.css_key_to_camel_case(parts[0].trim());
                    let value = parts[1].trim();
                    format!("{}: '{}'", key, value)
                } else {
                    String::new()
                }
            })
            .filter(|s| !s.trim().is_empty())
            .collect::<Vec<String>>()
            .join(",")
    }

    /// Converts css key for inline css to camelCase
    fn css_key_to_camel_case(&self, key: &str) -> String {
        key
            .split("-")
            .enumerate()
            .map(|(i, s)| {
                if i == 0 {
                    s.to_string()
                } else {
                    let mut chars = s.chars();
                    match chars.next() {
                        None => String::new(),
                        Some(first_character) => {
                            first_character.to_uppercase().chain(chars).collect()
                        }
                    }
                }
            })
            .collect::<String>()
    }

    /// Replace hardcoded width/height with props
    fn replace_dimensions(&self, svg: &str) -> String {
        let mut result = svg.to_string();
        
        let width_re = Regex::new(r#"width="(\d+)""#).unwrap();
        result = width_re.replace(&result, "width={size}").to_string();

        let height_re = Regex::new(r#"height="(\d+)""#).unwrap();
        result = height_re.replace(&result, "height={size}").to_string();

        result
    }

    fn replace_colors(&self, svg: &str) -> String {
        let mut result = svg.to_string();
        
        let color_patterns = vec![
            r##"fill="#[0-9A-Fa-f]{6}""##,
            r##"fill="#[0-9A-Fa-f]{3}""##,
            r##"stroke="#[0-9A-Fa-f]{6}""##,
            r##"stroke="#[0-9A-Fa-f]{3}""##,
        ];

        for pattern in color_patterns {
            let re = Regex::new(pattern).unwrap();
            result = re
                .replace_all(&result, |caps: &regex::Captures| {
                    let matched = &caps[0];
                    if matched.contains("white") || matched.contains("#fff") || matched.contains("#FFF") {
                        matched.to_string()
                    } else if matched.starts_with("fill=") {
                        "fill={color}".to_string()
                    } else {
                        "stroke={color}".to_string()
                    }
                })
                .to_string();
        }

        result
    }

    fn spread_props(&self, svg: &str) -> String {
        svg.replacen(">", " {...props}>", 1).trim().to_string()
    }

    fn wrap_in_component(&self, processed_svg: &str) -> String {
        let indented_svg = self.indent_svg(processed_svg, 4);

        let mut import_line = format!(r#"import React, {{SVGProps}} from "react";
interface {}Props extends SVGProps<SVGSVGElement> {{
    size?: `${{number}}` | number;
    color?: string;
}}
        "#, self.component_name);
        let mut props_type = format!(r#" : {}Props"#, self.component_name);
        if self.config.is_javascript {
            import_line = r#"import React from "react""#.to_string();
            props_type = "".to_string();
        }
        
        format!(
            r##"{}

const {} = ({{ 
    size = 24, 
    color = '#111827', 
    ...props
}}{}) => {{
    return (
{}
    );
}};

export default {};

// Usage examples:
// <{} />
// <{} size={{32}} color="#3B82F6" />
// <{} size="32" color="#3B82F6" />
// <{} className="hover:opacity-80" />
"##,
            import_line,
            self.component_name,
            props_type,
            indented_svg,
            self.component_name,
            self.component_name,
            self.component_name,
            self.component_name,
            self.component_name
        )
    }

    /// Indent SVG content
    fn indent_svg(&self, svg: &str, spaces: usize) -> String {        
        let mut result = String::new();
        let mut level = 2;
        let indent_str = " ".repeat(spaces);

        // Split by tags but keep them
        let replaced = svg
            .replace(">", ">\n")
            .replace("<", "\n<");
        let tokens = replaced
            .lines()
            .map(|l| l.trim())
            .filter(|l| !l.is_empty());

        for token in tokens {
            if token.starts_with("</") {
                if level > 0 {
                    level -= 1;
                }
                result.push_str(&format!("{}{}\n", indent_str.repeat(level), token));
            } else if token.starts_with("<") && token.ends_with("/>") {
                result.push_str(&format!("{}{}\n", indent_str.repeat(level), token));
            } else if token.starts_with("<") {
                result.push_str(&format!("{}{}\n", indent_str.repeat(level), token));
                level += 1;
            } else {
                result.push_str(&format!("{}{}\n", indent_str.repeat(level), token));
            }
        }

        result
    }

    /// Save component to file
    fn save_to_file(&self, component: &str) -> Result<PathBuf, Box<dyn std::error::Error>> {
        fs::create_dir_all(&self.config.destination_folder)?;
        let file_path = self.generate_file_path();
        fs::write(&file_path, component)?;

        Ok(file_path)
    }

    /// It generates the full file path
    fn generate_file_path(&self) -> PathBuf {
                let mut file_name = format!("{}.tsx", self.component_name);
        if self.config.is_javascript {
            file_name = format!("{}.jsx", self.component_name);
        }
        self.config.destination_folder.join(file_name)
    }

    fn check_component_existence(&self) -> Result<(), String> {
        let file_path = self.generate_file_path();
        if file_path.exists() {
            Err(format!("An icon already exists at: {:?}", file_path).to_string())
        } else {
            Ok(())
        }
    }

}