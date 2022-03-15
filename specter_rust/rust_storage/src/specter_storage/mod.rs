#![allow(unused_imports)]
#![allow(non_snake_case)]

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use std::ptr;
use std::str::FromStr;

use std::fs::File;
use std::fs::OpenOptions;
use std::io::{Write, SeekFrom, Seek, Read};
use std::path::Path;

use aes::Aes128;
use aes::cipher::{
    BlockCipher, BlockEncrypt, BlockDecrypt, KeyInit,
    generic_array::GenericArray,
};

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

const USED_VOLUMES: u8 = 5;
const CLUSTER_SIZE: usize = 1024;

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
    
        if !Path::new(filePath.as_str()).exists() {
            let mut file = File::create(filePath.as_str()).expect("Unable to open");
    
            for volumeIdx in 0..USED_VOLUMES {
                let my_struct = DiskHeaderVolume { volumeIndex: volumeIdx, reserved: [0; 128]};
                let bytes: &[u8] = unsafe { any_as_u8_slice(&my_struct) };
                file.write_all(bytes).expect("Unable write header");
            }
    
            print!("Header file created\n");
        }
    
        return true;
    }

    pub fn write_storage(&mut self, volumeIdx: i32, clusterIdx: i32, data: *const c_char, dataSize: i32) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (write): {}\n", filePath);

        
        if !Path::new(filePath.as_str()).exists() {
            let mut file = File::create(filePath.as_str()).expect("Unable to open");
    
            for _volumeIdx in 0..USED_VOLUMES {
                let bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
                file.write_all(&bytes).expect("Unable write empty data");
            }

            print!("Data file created\n");
        }

        //
        let mut file = OpenOptions::new().create(false).write(true).open(filePath.as_str()).expect("Unable open file to write");

        //
        let offsetStart = volumeIdx * CLUSTER_SIZE as i32;
        file.seek(SeekFrom::Start(offsetStart as u64)).expect("Unable to write to file");

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
        unsafe {
            let vec_ptr = bytes.as_mut_ptr() as *mut i8;
            if dataSize  as usize > CLUSTER_SIZE {
                return false;
            }
            ptr::copy_nonoverlapping(data as *mut i8, vec_ptr, dataSize as usize);
        }

        bytes = self.encrypt_cluster(bytes);

        file.write_all(&bytes).expect("Unable to write to file");
        
        return true;
    }

    pub fn read_storage(&mut self, volumeIdx: i32, clusterIdx: i32, data: *const c_char) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (read): {}\n", filePath);

        let mut file = File::open(filePath.as_str()).expect("Unable to open");
        let offsetStart = volumeIdx * CLUSTER_SIZE as i32;
        file.seek(SeekFrom::Start(offsetStart as u64)).expect("Unable to write to file");

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
        let vec_ptr = bytes.as_mut_ptr() as *mut i8;

        file.read_exact(&mut bytes).expect("Unable to read from file");

        bytes = self.decrypt_cluster(bytes);

        unsafe {
            ptr::copy_nonoverlapping(vec_ptr, data as *mut i8, 100);
        }

        return true;
    }

    fn encrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE]) -> [u8; CLUSTER_SIZE] {
        let key = GenericArray::from([0u8; 16]);
        let mut block = GenericArray::from([42u8; 16]);

        //Initialize cipher
        let cipher = Aes128::new(&key);

        let blocks = CLUSTER_SIZE / 16;
        for i in 0..blocks {
            let a = 16 * i;
            let b = 16 * (i + 1);
            block.copy_from_slice(&bytes[a..b]);

            let block_copy = block.clone();

            //Encrypt block in-place
            cipher.encrypt_block(&mut block);

            //Copy in bytes
            unsafe {
                let block_ptr = block.as_mut_ptr();

                let vec_ptr = bytes.as_mut_ptr().offset((i * 16) as isize) as *mut u8;
                ptr::copy_nonoverlapping(block_ptr, vec_ptr, 16);
            }

            //Self-test
            {
                let mut block2 = GenericArray::from([42u8; 16]);
                unsafe {
                    let block_ptr = block2.as_mut_ptr();
                    let vec_ptr = bytes.as_mut_ptr().offset((i * 16) as isize) as *mut u8;
                    ptr::copy_nonoverlapping(vec_ptr, block_ptr, 16);
                }

                //And decrypt it back
                cipher.decrypt_block(&mut block2);
                assert_eq!(block2, block_copy);
            }
        }
        return bytes;
    }

    fn decrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE]) -> [u8; CLUSTER_SIZE] {
        let key = GenericArray::from([0u8; 16]);
        let mut block = GenericArray::from([42u8; 16]);

        //Initialize cipher
        let cipher = Aes128::new(&key);

        let blocks = CLUSTER_SIZE / 16;
        for i in 0..blocks {
            let a = 16 * i;
            let b = 16 * (i + 1);
            block.copy_from_slice(&bytes[a..b]);

            //Decrypt block
            cipher.decrypt_block(&mut block);

            //Copy in bytes
            unsafe {
                let block_ptr = block.as_mut_ptr();
                let vec_ptr = bytes.as_mut_ptr().offset((i * 16) as isize) as *mut u8;
                ptr::copy_nonoverlapping(block_ptr, vec_ptr, 16);
            }
        }
        return bytes;
    }
}
static mut DISK_STORAGE: DiskStorage = DiskStorage {
    dataDir: ""
};

#[no_mangle]
pub extern fn open_storage(path: *const c_char) -> bool {
    unsafe {
        return DISK_STORAGE.open_storage(path);
    }
}

pub extern fn read_storage(volumeIdx: i32, clusterIdx: i32, data: *const c_char) -> bool {
    unsafe {
        return DISK_STORAGE.read_storage(volumeIdx, clusterIdx, data);
    }
}

pub extern fn write_storage(volumeIdx: i32, clusterIdx: i32, data: *const c_char, dataSize: i32) -> bool {
    unsafe {
        return DISK_STORAGE.write_storage(volumeIdx, clusterIdx, data, dataSize);
    }
}