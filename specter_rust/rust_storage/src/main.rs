#![allow(non_snake_case)]

pub mod specter_storage;

use std::ffi::{CString};

fn main() {
    println!("Hello, world!");

    let path = CString::new( "/home/linux-dev/Documents/flutter-apps/other/tmp".to_owned()).unwrap().into_raw();
    let isOk = specter_storage::open_storage(path);

    let strA = CString::new("testA").expect("CString::new failed");
    specter_storage::write_storage(0, 0, strA.as_ptr(), 5);

    let mut bytes: [u8; 1024] = [0; 1024];
    specter_storage::read_storage(0, 0, bytes.as_mut_ptr() as *const i8);

    let s = match std::str::from_utf8(&bytes) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    println!("check: {}", s);
}