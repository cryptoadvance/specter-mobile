#![allow(non_snake_case)]

pub mod specter_storage;

use std::{ffi::{CString}, os::raw::c_char};

fn main() {
    println!("Hello, world!");

    {
        let path = CString::new( "/home/linux-dev/Documents/flutter-apps/other/tmp".to_owned()).unwrap().into_raw();
        let mut _isOk = specter_storage::ds_open_storage(path);
    }

    let strA = CString::new("pass1").expect("CString::new failed");
    let mut _isOk = specter_storage::ds_create_volume(1, strA.as_ptr());
    if (_isOk != 1) {
        println!("Can not create volume");
        return;
    }

    /*if specter_storage::ds_open_volume(0, strA.as_ptr()) != 1 {
        println!("Can not open volume");
        return;
    }*/
    let strB = CString::new("pass1").expect("CString::new failed");
    let volumeIdx = specter_storage::ds_find_volume_and_open(strB.as_ptr());
    if (volumeIdx < 0) {
        println!("Can not find volume and open");
        return;
    }

    let strA = CString::new("testA").expect("CString::new failed");
    specter_storage::ds_write_storage(volumeIdx as u32, 0, strA.as_ptr(), 5);

    let mut bytes: [u8; 1024] = [0; 1024];
    specter_storage::ds_read_storage(volumeIdx as u32, 0, bytes.as_mut_ptr() as *const i8, 1024);

    let s = match std::str::from_utf8(&bytes) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    println!("check: {}", s);
}