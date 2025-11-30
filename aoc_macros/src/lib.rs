use proc_macro::TokenStream;
use quote::quote;
use syn::parse::{Parse, ParseStream};
use syn::punctuated::Punctuated;
use syn::{parse_macro_input, ItemFn, Lit, Token};

struct AocArgs {
    year: u32,
    day: u32,
    part: u32,
}

impl Parse for AocArgs {
    fn parse(input: ParseStream) -> syn::Result<Self> {
        let args: Punctuated<Lit, Token![,]> = input.parse_terminated(Lit::parse, Token![,])?;

        if args.len() < 2 || args.len() > 3 {
            return Err(syn::Error::new_spanned(
                &args,
                "Expected 2 or 3 arguments: year, day[, part]",
            ));
        }

        let year = match &args[0] {
            Lit::Int(lit) => lit.base10_parse()?,
            _ => return Err(syn::Error::new_spanned(&args[0], "Year must be an integer")),
        };

        let day = match &args[1] {
            Lit::Int(lit) => lit.base10_parse()?,
            _ => return Err(syn::Error::new_spanned(&args[1], "Day must be an integer")),
        };

        let part = if args.len() >= 3 {
            match &args[2] {
                Lit::Int(lit) => lit.base10_parse()?,
                _ => return Err(syn::Error::new_spanned(&args[2], "Part must be an integer")),
            }
        } else {
            1
        };

        Ok(AocArgs { year, day, part })
    }
}

/// A procedural macro that registers Advent of Code solutions.
///
/// Usage: #[aoc(year, day, part)]
/// - year: The year of the challenge (e.g., 2024)
/// - day: The day of the challenge (1-25)
/// - part: Optional part number (1 or 2, defaults to 1)
///
/// The annotated function must have the signature: fn(input: &str) -> String
#[proc_macro_attribute]
pub fn aoc(args: TokenStream, input: TokenStream) -> TokenStream {
    let args = parse_macro_input!(args as AocArgs);
    let func = parse_macro_input!(input as ItemFn);

    let func_name = &func.sig.ident;
    let year = args.year;
    let day = args.day;
    let part = args.part;

    // Generate registration code
    let registration_fn_name = syn::Ident::new(
        &format!("__register_{}_{}_{}_{}", year, day, part, func_name),
        func_name.span(),
    );

    let expanded = quote! {
        #func

        #[ctor::ctor]
        fn #registration_fn_name() {
            crate::registry::REGISTRY.register_solution(
                #year,
                #day,
                #part,
                stringify!(#func_name),
                #func_name,
            );
        }
    };

    TokenStream::from(expanded)
}
