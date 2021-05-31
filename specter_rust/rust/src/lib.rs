use std::os::raw::{c_char};
use std::ffi::{CString, CStr};

mod bitcoin_demo;

#[no_mangle]
pub extern fn rust_greeting(to: *const c_char) -> *mut c_char {
    let c_str = unsafe { CStr::from_ptr(to) };
    let recipient = match c_str.to_str() {
        Err(_) => "there",
        Ok(string) => string,
    };

    CString::new("Hello ".to_owned() + recipient).unwrap().into_raw()
}

#[no_mangle]
pub extern fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() { return }
        CString::from_raw(s)
    };
}

#[no_mangle]
pub extern fn run_bitcoin_demo() -> *mut c_char {
    let log = bitcoin_demo::run().unwrap();
    CString::new(log).unwrap().into_raw()
}

#[cfg(test)]
mod tests {
    use std::ffi::{CString, CStr};

    #[test]
    fn rust_greeting() {
        let name = CString::new("Alice").unwrap();
        let res = super::rust_greeting(name.as_ptr());
        let res_cstr = unsafe { CStr::from_ptr(res) };
        assert_eq!(res_cstr.to_str().unwrap(), "Hello Alice");
        super::rust_cstr_free(res);
    }
}
