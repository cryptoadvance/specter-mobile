#![allow(unused_imports)]
#![allow(non_snake_case)]

use std::os::raw::{c_char};
use std::ffi::{CString, CStr};
use std::os::unix::prelude::MetadataExt;
use std::{ptr, mem};
use std::str::FromStr;

use std::fs::File;
use std::fs::OpenOptions;
use std::io::{Write, SeekFrom, Seek, Read};
use std::path::Path;

use orion::kdf;
use rand::prelude::*;

use aes::cipher::{
    BlockCipher, BlockEncrypt, BlockDecrypt, KeyInit,
};

use aes::{Aes128, cipher::generic_array::GenericArray};
use xts_mode::{Xts128, get_tweak_default};

struct DiskHeaderInit {
    salt: [u8; 16],
    reserved: [u8; 128]
}

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
const HEADER_SIZE: usize = 1024;
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
            self.storage_init(filePath);
        }
    
        return true;
    }

    fn storage_init(&mut self, filePath: String) {
        let mut file = File::create(filePath.as_str()).expect("Unable to open");

        let salt: [u8; 16] = self.get_storage_salt();

        let headerInit = DiskHeaderInit { salt: salt, reserved: [0; 128]};
        let bytes = unsafe { any_as_u8_slice(&headerInit) };
        file.write_all(&bytes).expect("Unable write header");
    
        for _volumeIdx in 0..USED_VOLUMES {
            let headerData = self.get_storage_rnd_header();
            file.write_all(&headerData).expect("Unable write header");
        }

        print!("Header file created\n");
    }

    fn get_storage_rnd_header(&mut self) -> Vec<u8> {
        let headerSize = CLUSTER_SIZE;
        let mut data = vec![0u8; headerSize];
        let mut rng = rand::thread_rng();

        for i in 0..headerSize {
            data[i] = rng.gen();
        }
        return data;
    }

    fn get_storage_salt(&mut self) -> [u8; 16] {
        let mut salt: [u8; 16] = [0; 16];
        let mut rng = rand::thread_rng();
        for i in 0..16 {
            salt[i] = rng.gen();
        }
        return salt;
    }

    pub fn create_volume(&mut self, volumeIdx: u32, pass: *const c_char) -> bool {
        print!("Create volume: {}\n", volumeIdx);

        let filePath= self.dataDir.to_string() + "/header.raw";

        let mut file = OpenOptions::new().create(false).read(true).write(true).open(filePath.as_str()).expect("Unable open file to write");

        //Read header data
        let mut headerData = vec![0u8; mem::size_of::<DiskHeaderInit>()];
        file.read_exact(&mut headerData).expect("Unable to read from file");
        let _header: &DiskHeaderInit;
        unsafe {
            let header_p: *const DiskHeaderInit = headerData.as_ptr() as *const DiskHeaderInit;
            _header = &*header_p;
        }

        //
        let offsetStart = volumeIdx * CLUSTER_SIZE as u32;
        file.seek(SeekFrom::Current(offsetStart as i64)).expect("Unable to write to file");

        //
        let header = DiskHeaderVolume { volumeIndex: volumeIdx as u8, reserved: [0; 128]};

        //Encrypt header
        let data = self.encrypt_header(header);

        file.write_all(&data).expect("Unable to write to file");

        return true;
    }

    pub fn write_storage_init(&mut self, clusterIdx: u32) {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        let mut file = File::create(filePath.as_str()).expect("Unable to open");

        for _volumeIdx in 0..USED_VOLUMES {
            let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
            bytes = self.encrypt_cluster(bytes, clusterIdx + 1);
            file.write_all(&bytes).expect("Unable write empty data");
        }

        print!("Data file created\n");
    }

    pub fn write_storage(&mut self, volumeIdx: i32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (write): {}\n", filePath);
        if !Path::new(filePath.as_str()).exists() {
            self.write_storage_init(clusterIdx);
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

        //Use (clusterIdx + 1) because (clusterIdx == 0) it`s header
        bytes = self.encrypt_cluster(bytes, clusterIdx + 1);

        file.write_all(&bytes).expect("Unable to write to file");
        
        return true;
    }

    pub fn read_storage(&mut self, volumeIdx: i32, clusterIdx: u32, data: *const c_char) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (read): {}\n", filePath);

        let mut file = File::open(filePath.as_str()).expect("Unable to open");
        let offsetStart = volumeIdx * CLUSTER_SIZE as i32;
        file.seek(SeekFrom::Start(offsetStart as u64)).expect("Unable to write to file");

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
       
        file.read_exact(&mut bytes).expect("Unable to read from file");

        //Use (clusterIdx + 1) because (clusterIdx == 0) it`s header
        bytes = self.decrypt_cluster(bytes, clusterIdx + 1);

        unsafe {
            let vec_ptr = bytes.as_mut_ptr() as *mut i8;
            ptr::copy_nonoverlapping(vec_ptr, data as *mut i8, CLUSTER_SIZE);
        }

        return true;
    }

    fn encrypt_header(&mut self, header: DiskHeaderVolume) -> [u8; HEADER_SIZE] {
        let headerData: &[u8] = unsafe { any_as_u8_slice(&header) };

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
        let dataSize = headerData.len();
        unsafe {
            let vec_ptr = bytes.as_mut_ptr() as *mut i8;
            if dataSize  as usize > CLUSTER_SIZE {
                panic!("Error");
            }
            ptr::copy_nonoverlapping(headerData.as_ptr() as *mut i8, vec_ptr, dataSize as usize);
        }

        bytes = self.encrypt_cluster(bytes, 0);

        return  bytes;
    }

    fn get_xts_cipher(&mut self) -> Xts128::<Aes128> {
        let saltBytes:[u8; 16] = [0u8; 16];
        
        let mut key = GenericArray::from([0u8; 32]);

        let password  = kdf::Password::from_slice(b"User password").expect("Wrong password");
        let salt = kdf::Salt::from_slice(&saltBytes).expect("Can not convert salt");
        let derivedKey = kdf::derive_key(&password, &salt, 3, 1<<8, 32).expect("Can not derive key");
        let derivedKeyBytes = derivedKey.unprotected_as_bytes();
        key.copy_from_slice(&derivedKeyBytes);

        //
        let cipher_1 = Aes128::new(GenericArray::from_slice(&key[..16]));
        let cipher_2 = Aes128::new(GenericArray::from_slice(&key[16..]));
        let xts = Xts128::<Aes128>::new(cipher_1, cipher_2);
        return xts;
    }

    fn encrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE], clusterIndex: u32) -> [u8; CLUSTER_SIZE] {
        //Initialize cipher
        let xts = self.get_xts_cipher();

        //
        xts.encrypt_area(&mut bytes, CLUSTER_SIZE, clusterIndex as u128, get_tweak_default);
        return bytes;
    }

    fn decrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE], clusterIndex: u32) -> [u8; CLUSTER_SIZE] {
        //Initialize cipher
        let xts = self.get_xts_cipher();

        //
        xts.decrypt_area(&mut bytes, CLUSTER_SIZE, clusterIndex as u128, get_tweak_default);
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

pub extern fn create_volume(volumeIdx: u32, pass: *const c_char) -> bool {
    unsafe {
        return DISK_STORAGE.create_volume(volumeIdx, pass);
    }
}

pub extern fn read_storage(volumeIdx: i32, clusterIdx: u32, data: *const c_char) -> bool {
    unsafe {
        return DISK_STORAGE.read_storage(volumeIdx, clusterIdx, data);
    }
}

pub extern fn write_storage(volumeIdx: i32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> bool {
    unsafe {
        return DISK_STORAGE.write_storage(volumeIdx, clusterIdx, data, dataSize);
    }
}