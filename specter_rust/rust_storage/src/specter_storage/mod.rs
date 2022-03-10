#![allow(unused_imports)]

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use std::str::FromStr;

use std::fs::File;
use std::io::Write;
use std::path::Path;

struct DiskHeaderVolume {
    volumeIndex: u8,
    reserved: [u8; 128]
}

unsafe fn any_as_u8_slice<T: Sized>(p: &T) -> &[u8] {
    ::std::slice::from_raw_parts(
        (p as *const T) as *const u8,
        ::std::mem::size_of::<T>(),
    )
}

#[no_mangle]
pub extern fn open_storage(path: *const c_char) -> *mut c_char {
    let pathStr: &CStr = unsafe { CStr::from_ptr(path) };
    let dataDir: String = pathStr.to_str().unwrap().to_owned();
    let filePath = dataDir + "/header.raw";
    let usedVolumes = 5;

    if !Path::new(filePath.as_str()).exists() {
        let mut file = File::create(filePath.as_str()).expect("Unable to open");

        for volumeIdx in 0..usedVolumes {
            let my_struct = DiskHeaderVolume { volumeIndex: volumeIdx, reserved: [0; 128]};
            let bytes: &[u8] = unsafe { any_as_u8_slice(&my_struct) };
            file.write_all(bytes);
        }

        print!("Header file created\n");
    }

    CString::new("ok").unwrap().into_raw()
}
