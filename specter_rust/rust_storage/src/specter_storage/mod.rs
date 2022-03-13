#![allow(unused_imports)]
#![allow(non_snake_case)]

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use std::ptr;
use std::str::FromStr;

use std::fs::File;
use std::io::{Write, SeekFrom, Seek};
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

struct DiskStorage {
     dataDir: &'static str
}
impl DiskStorage {
    pub fn open_storage(&mut self, path: *const c_char) -> bool {
        let pathStr: &CStr = unsafe { CStr::from_ptr(path) };
        let str_slice: &str = pathStr.to_str().unwrap();

        let filePath;
        self.dataDir = str_slice;
        filePath = self.dataDir.to_string() + "/header.raw";

        print!("Open header: {}\n", filePath);
        
        const USED_VOLUMES: u8 = 5;
    
        if !Path::new(filePath.as_str()).exists() {
            let mut file = File::create(filePath.as_str()).expect("Unable to open");
    
            for volumeIdx in 0..USED_VOLUMES {
                let my_struct = DiskHeaderVolume { volumeIndex: volumeIdx, reserved: [0; 128]};
                let bytes: &[u8] = unsafe { any_as_u8_slice(&my_struct) };
                file.write_all(bytes);
            }
    
            print!("Header file created\n");
        }
    
        return true;
    }

    pub fn write_storage(&mut self, volumeIdx: i32, clusterIdx: i32, data: *const c_char, dataSize: i32) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage: {}\n", filePath);

        const USED_VOLUMES: u8 = 5;
        const CLUSTER_SIZE: usize = 1024;

        if !Path::new(filePath.as_str()).exists() {
            let mut file = File::create(filePath.as_str()).expect("Unable to open");
    
            for volumeIdx in 0..USED_VOLUMES {
                let bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
                file.write_all(&bytes);
            }

            print!("Data file created\n");
        }

        let mut file = File::create(filePath.as_str()).expect("Unable to open");
        let offsetStart = volumeIdx * CLUSTER_SIZE as i32;
        file.seek(SeekFrom::Start(offsetStart as u64)).expect("Unable to write to file");

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];

        file.write_all(&bytes);
        
        return true;
    }
}
static mut diskStorage: DiskStorage = DiskStorage {
    dataDir: ""
};

#[no_mangle]
pub extern fn open_storage(path: *const c_char) -> bool {
    unsafe {
        return diskStorage.open_storage(path);
    }
}

pub extern fn read_storage(volumeIdx: *const i32, data: *const c_char, cluster_idx: i32) -> bool {
    return true;
}

pub extern fn write_storage(volumeIdx: i32, clusterIdx: i32, data: *const c_char, dataSize: i32) -> bool {
    unsafe {
        return diskStorage.write_storage(volumeIdx, clusterIdx, data, dataSize);
    }
}