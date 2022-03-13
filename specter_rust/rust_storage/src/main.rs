#![allow(non_snake_case)]

pub mod specter_storage;

use std::ffi::{CString};

fn main() {
    println!("Hello, world!");

    let path = CString::new( "/home/linux-dev/Documents/flutter-apps/other/tmp".to_owned()).unwrap().into_raw();
    let isOk = specter_storage::open_storage(path);

    let c_to_print = CString::new("test").expect("CString::new failed");

    specter_storage::write_storage(0, 0, c_to_print.as_ptr(), 4);
}