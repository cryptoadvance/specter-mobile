pub mod specter_storage;

use std::ffi::{CString, CStr};

fn main() {
    println!("Hello, world!");

    unsafe { 
        let path = CString::new( "/home/linux-dev/Documents/flutter-apps/other/tmp".to_owned()).unwrap().into_raw();
        let y = specter_storage::open_storage(path);

        let slice = CStr::from_ptr(y);
        let sv = slice.to_string_lossy().into_owned();
        
        println!("{}", sv);
    }
    
}