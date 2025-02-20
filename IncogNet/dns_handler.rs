use std::fs;
use std::process::Command;
use std::os::raw::c_int;

#[no_mangle]
pub extern "C" fn clear_dns_cache() -> c_int {
    let os = std::env::consts::OS;
    
    let status = match os {
        "linux" => Command::new("systemd-resolve")
            .arg("--flush-caches")
            .status(),
        "macos" => Command::new("dscacheutil")
            .arg("-flushcache")
            .status(),
        "windows" => Command::new("ipconfig")
            .arg("/flushdns")
            .status(),
        _ => return 0,
    };

    match status {
        Ok(_) => 1,
        Err(_) => 0,
    }
}

#[no_mangle]
pub extern "C" fn modify_dns(dns_server: *const c_char) -> c_int {
    let dns = unsafe { CStr::from_ptr(dns_server).to_string_lossy().into_owned() };
    
    let content = format!("nameserver {}\n", dns);
    
    match fs::write("/etc/resolv.conf", content) {
        Ok(_) => 1,
        Err(_) => 0,
    }
}

#[no_mangle]
pub extern "C" fn list_current_dns() -> c_int {
    match fs::read_to_string("/etc/resolv.conf") {
        Ok(contents) => {
            println!("{}", contents);
            1
        },
        Err(_) => 0,
    }
}
