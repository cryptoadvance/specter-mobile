#![allow(unused_imports)]
#![allow(non_snake_case)]
#![allow(unused_parens)]

use std::ops::RangeBounds;
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

use std::collections::HashMap;

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

struct OpenedVolume {
    volumeIdx: u32,
    volumeKey: [u8; 32]
}

struct DiskStorage {
    isOpened: bool,
    dataDir: String,
    openedVolumes: Option<HashMap<u32, OpenedVolume>>
}
impl DiskStorage {
    pub fn open_storage(&mut self, path: *const c_char) -> bool {
        let pathStr: &CStr = unsafe { CStr::from_ptr(path) };
        let str_slice: &str = pathStr.to_str().unwrap().clone();

        let filePath;
        self.dataDir = str_slice.to_string();
        filePath = self.dataDir.to_string() + "/header.raw";

        print!("Open header: {}\n", filePath);
    
        if !Path::new(filePath.as_str()).exists() {
            self.storage_init(filePath);
        }

       unsafe {
            DISK_STORAGE.openedVolumes = Some(HashMap::new());
        }
        return true;
    }

    fn storage_init(&mut self, filePath: String) {
        let mut file = File::create(filePath.as_str()).expect("Unable to open");

        let salt: [u8; 16] = self.get_storage_salt();

        let headerInit = DiskHeaderInit { salt, reserved: [0; 128]};
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

    fn get_storage_rnd_cluster(&mut self) -> Vec<u8> {
        let headerSize = CLUSTER_SIZE;
        let mut data = vec![0u8; headerSize];
        let mut rng = rand::thread_rng();

        for i in 0..headerSize {
            data[i] = rng.gen();
        }
        return data;
    }

    fn derive_volume_key(&mut self, pass: *const c_char, saltBytes: [u8; 16]) -> [u8; 32] {
        let c_str: &CStr = unsafe { CStr::from_ptr(pass) };
        let str_slice: &str = c_str.to_str().unwrap();
        let password  = kdf::Password::from_slice(str_slice.as_bytes()).expect("Wrong password");

        let salt = kdf::Salt::from_slice(&saltBytes).expect("Can not convert salt");
        let derivedKey = kdf::derive_key(&password, &salt, 3, 1<<8, 32).expect("Can not derive key");
        let derivedKeyBytes = derivedKey.unprotected_as_bytes();

        let mut retKey:[u8; 32] = [0u8; 32];
        retKey.copy_from_slice(derivedKeyBytes);
        return retKey;
    }

    fn set_volume_key(&mut self, volumeIdx: u32, derivedKeyBytes: [u8; 32]) -> bool {
        let obj = OpenedVolume {
            volumeIdx: volumeIdx,
            volumeKey: derivedKeyBytes
        };

        let openedVolumes = self.openedVolumes.as_mut().unwrap();
        openedVolumes.insert(volumeIdx, obj);
        return true;
    }

    fn get_volume_key(&mut self, volumeIdx: u32) -> [u8; 32] {
        let openedVolumes = self.openedVolumes.as_mut().unwrap();
        let obj = openedVolumes.get(&volumeIdx);
        if (obj.is_none()) {
            panic!("volume not opened");
        }

        let objPointer = obj.unwrap();
        if (objPointer.volumeIdx != volumeIdx) {
            panic!("wrong volume");
        }
        return objPointer.volumeKey;
    }

    pub fn create_volume(&mut self, volumeIdx: u32, pass: *const c_char) -> bool {
        print!("Create volume: {}\n", volumeIdx);

        {
            let openedVolumes = self.openedVolumes.as_ref().unwrap();
            if openedVolumes.contains_key(&volumeIdx) {
                return false;
            }
        }

        let filePath = self.dataDir.to_string() + "/header.raw";
        let mut file = OpenOptions::new().create(false).read(true).write(true).open(filePath).expect("Unable open file to write");

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
        file.seek(SeekFrom::Current(offsetStart as i64)).expect("Unable to seek in the file");

        //
        let derivedKeyBytes:[u8; 32] = self.derive_volume_key(pass, _header.salt);
        self.set_volume_key(volumeIdx, derivedKeyBytes);

        //
        let header = DiskHeaderVolume { volumeIndex: volumeIdx as u8, reserved: [0; 128]};

        //Encrypt header
        let data = self.encrypt_header(header, volumeIdx);

        file.write_all(&data).expect("Unable to write to file");

        return true;
    }

    pub fn find_volume_and_open(&mut self, pass: *const c_char) -> i32 {
        print!("Try find volume\n");

        let filePath = self.dataDir.to_string() + "/header.raw";

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
        let derivedKeyBytes:[u8; 32] = self.derive_volume_key(pass, _header.salt);

        //Seek volume header
        let mut findVolumeIdx:i32 = -1;
        for volumeIdx in 0..USED_VOLUMES {
            print!("test {}\n", volumeIdx);

            //let offsetStart = (volumeIdx as u32) * CLUSTER_SIZE as u32;
            //file.seek(SeekFrom::Current(offsetStart as i64)).expect("Unable to seek in the file");

            //
            let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
            let res = file.read_exact(&mut bytes);
            let res = match res {
                Ok(res) => res,
                Err(error) => break
            };

            //Try decrypt volume header
            {
                let xts = self.get_xts_cipher(derivedKeyBytes);
                xts.decrypt_area(&mut bytes, CLUSTER_SIZE, 0 as u128, get_tweak_default);
            }

            let _headerVolume: &DiskHeaderVolume;
            unsafe {
                let header_p: *const DiskHeaderVolume = bytes.as_ptr() as *const DiskHeaderVolume;
                _headerVolume = &*header_p;
            }

            if (_headerVolume.volumeIndex == volumeIdx as u8) {
                findVolumeIdx = volumeIdx as i32;
                break;
            }
        }

        //
        if (findVolumeIdx < 0) {
            return -1;
        }

        //
        print!("Find volume: {}\n", findVolumeIdx);

        //
        let openedVolumes = self.openedVolumes.as_ref().unwrap();
        if openedVolumes.contains_key(&(findVolumeIdx as u32)) {
            print!("Volume {} already open\n", findVolumeIdx);
            return findVolumeIdx;
        }

        //Volume opened
        self.set_volume_key(findVolumeIdx as u32, derivedKeyBytes);
        return findVolumeIdx;
    }

    pub fn write_storage_init(&mut self, clusterIdx: u32) {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        let mut file = File::create(filePath.as_str()).expect("Unable to open");

        for _volumeIdx in 0..USED_VOLUMES {
            let clusterData = self.get_storage_rnd_header();
            file.write_all(&clusterData).expect("Unable write empty data");
        }

        print!("Data file created\n");
    }

    pub fn write_storage(&mut self, volumeIdx: u32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (write): {}\n", filePath);
        if !Path::new(filePath.as_str()).exists() {
            self.write_storage_init(clusterIdx);
        }

        //
        let mut file = OpenOptions::new().create(false).write(true).open(filePath.as_str()).expect("Unable open file to write");

        //
        let offsetStart = volumeIdx * CLUSTER_SIZE as u32;
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
        bytes = self.encrypt_cluster(bytes, volumeIdx, clusterIdx + 1);

        file.write_all(&bytes).expect("Unable to write to file");
        
        return true;
    }

    pub fn read_storage(&mut self, volumeIdx: u32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> bool {
        let filePath;
        filePath = self.dataDir.to_string() + &"/data_".to_string() + &clusterIdx.to_string() + ".raw";

        print!("Open storage (read): {}\n", filePath);

        if dataSize as usize != CLUSTER_SIZE {
            return false;
        }

        if !Path::new(filePath.as_str()).exists() {
            let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
            unsafe {
                let vec_ptr = bytes.as_mut_ptr() as *mut i8;
                ptr::copy_nonoverlapping(vec_ptr, data as *mut i8, CLUSTER_SIZE);
            }
            return true;
        }

        let mut file = File::open(filePath.as_str()).expect("Unable to open");
        let offsetStart = volumeIdx * CLUSTER_SIZE as u32;
        file.seek(SeekFrom::Start(offsetStart as u64)).expect("Unable to write to file");

        let mut bytes: [u8; CLUSTER_SIZE] = [0; CLUSTER_SIZE];
       
        file.read_exact(&mut bytes).expect("Unable to read from file");

        //Use (clusterIdx + 1) because (clusterIdx == 0) it`s header
        bytes = self.decrypt_cluster(bytes, volumeIdx, clusterIdx + 1);

        unsafe {
            let vec_ptr = bytes.as_mut_ptr() as *mut i8;
            ptr::copy_nonoverlapping(vec_ptr, data as *mut i8, CLUSTER_SIZE);
        }

        return true;
    }

    fn encrypt_header(&mut self, header: DiskHeaderVolume, volumeIdx: u32) -> [u8; HEADER_SIZE] {
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

        bytes = self.encrypt_cluster(bytes, volumeIdx, 0);
 
        return  bytes;
    }

    fn get_xts_cipher(&mut self, derivedKeyBytes: [u8; 32]) -> Xts128::<Aes128> {
        let mut key = GenericArray::from([0u8; 32]);
        key.copy_from_slice(&derivedKeyBytes);

        //
        let cipher_1 = Aes128::new(GenericArray::from_slice(&key[..16]));
        let cipher_2 = Aes128::new(GenericArray::from_slice(&key[16..]));
        let xts = Xts128::<Aes128>::new(cipher_1, cipher_2);
        return xts;
    }

    fn encrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE], volumeIdx: u32, clusterIndex: u32) -> [u8; CLUSTER_SIZE] {
        //Initialize cipher
        let derivedKeyBytes = self.get_volume_key(volumeIdx);
        let xts = self.get_xts_cipher(derivedKeyBytes);

        //
        xts.encrypt_area(&mut bytes, CLUSTER_SIZE, clusterIndex as u128, get_tweak_default);
        return bytes;
    }

    fn decrypt_cluster(&mut self, mut bytes: [u8; CLUSTER_SIZE], volumeIdx: u32, clusterIndex: u32) -> [u8; CLUSTER_SIZE] {
        //Initialize cipher
        let derivedKeyBytes = self.get_volume_key(volumeIdx);
        let xts = self.get_xts_cipher(derivedKeyBytes);

        //
        xts.decrypt_area(&mut bytes, CLUSTER_SIZE, clusterIndex as u128, get_tweak_default);
        return bytes;
    }
}
static mut DISK_STORAGE: DiskStorage = DiskStorage {
    isOpened: false,
    dataDir: String::new(),
    openedVolumes: None
};

#[no_mangle]
pub extern fn ds_open_storage(path: *const c_char) -> i32 {
    unsafe {
        if (DISK_STORAGE.isOpened) {
            return 0;
        }
        
        if (!DISK_STORAGE.open_storage(path)) {
            return 0;
        }
        DISK_STORAGE.isOpened = true;
        return 1;
    }
}

#[no_mangle]
pub extern fn ds_create_volume(volumeIdx: u32, pass: *const c_char) -> i32 {
    unsafe {
        if (!DISK_STORAGE.isOpened) {
            return 0;
        }
        if (DISK_STORAGE.create_volume(volumeIdx, pass)) {
            return 1;
        }
        return 0;
    }
}

#[no_mangle]
pub extern fn ds_find_volume_and_open(pass: *const c_char) -> i32 {
    unsafe {
        if (!DISK_STORAGE.isOpened) {
            return -1;
        }
        return DISK_STORAGE.find_volume_and_open(pass);
    }
}

#[no_mangle]
pub extern fn ds_read_storage(volumeIdx: u32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> i32 {
    unsafe {
        if (!DISK_STORAGE.isOpened) {
            return 0;
        }
        if (DISK_STORAGE.read_storage(volumeIdx, clusterIdx, data, dataSize)) {
            return 1;
        }
        return 0;
    }
}

#[no_mangle]
pub extern fn ds_write_storage(volumeIdx: u32, clusterIdx: u32, data: *const c_char, dataSize: i32) -> i32 {
    unsafe {
        if (!DISK_STORAGE.isOpened) {
            return 0;
        }
        if (DISK_STORAGE.write_storage(volumeIdx, clusterIdx, data, dataSize)) {
            return 1;
        }
        return 0;
    }
}