use std::fs::{File, OpenOptions};
use std::io::{Read, Write, Seek, SeekFrom};
use std::path::Path;
use rand::{thread_rng, Rng};
use clap::{App, Arg};

const AUTHOR: &str = "Jashin L.";

struct BioScrambler {
    passes: u32,
    verify: bool,
    zero_fill: bool
}

impl BioScrambler {
    fn new(passes: u32, verify: bool, zero_fill: bool) -> Self {
        BioScrambler {
            passes,
            verify,
            zero_fill
        }
    }

    fn shred_file(&self, path: &Path) -> Result<(), std::io::Error> {
        let mut file = OpenOptions::new()
            .read(true)
            .write(true)
            .open(path)?;
        
        let file_size = file.metadata()?.len();
        
        for pass in 0..self.passes {
            self.overwrite_pass(&mut file, file_size, pass)?;
            
            if self.verify {
                self.verify_pass(&mut file, file_size, pass)?;
            }
        }
        
        if self.zero_fill {
            self.zero_fill_pass(&mut file, file_size)?;
        }
        
        std::fs::remove_file(path)?;
        Ok(())
    }

    fn overwrite_pass(&self, file: &mut File, size: u64, pass: u32) -> Result<(), std::io::Error> {
        let mut rng = thread_rng();
        let mut buffer = vec![0u8; 8192];
        
        file.seek(SeekFrom::Start(0))?;
        
        for _ in 0..(size / 8192) {
            rng.fill(&mut buffer[..]);
            file.write_all(&buffer)?;
        }
        
        let remainder = (size % 8192) as usize;
        if remainder > 0 {
            rng.fill(&mut buffer[..remainder]);
            file.write_all(&buffer[..remainder])?;
        }
        
        file.sync_all()?;
        Ok(())
    }

    fn verify_pass(&self, file: &mut File, size: u64, pass: u32) -> Result<(), std::io::Error> {
        let mut buffer = vec![0u8; 8192];
        file.seek(SeekFrom::Start(0))?;
        
        while file.read(&mut buffer)? > 0 {
            if buffer.iter().all(|&x| x == 0) {
                return Err(std::io::Error::new(
                    std::io::ErrorKind::Other,
                    format!("Verification failed on pass {}", pass)
                ));
            }
        }
        Ok(())
    }

    fn zero_fill_pass(&self, file: &mut File, size: u64) -> Result<(), std::io::Error> {
        let buffer = vec![0u8; 8192];
        file.seek(SeekFrom::Start(0))?;
        
        for _ in 0..(size / 8192) {
            file.write_all(&buffer)?;
        }
        
        let remainder = (size % 8192) as usize;
        if remainder > 0 {
            file.write_all(&buffer[..remainder])?;
        }
        
        file.sync_all()?;
        Ok(())
    }
}

fn main() {
    let matches = App::new("BioScrambler")
        .version("1.0")
        .author(AUTHOR)
        .about("Secure Data Shredding Tool")
        .arg(Arg::with_name("file")
            .required(true)
            .help("File to shred"))
        .arg(Arg::with_name("passes")
            .short("p")
            .long("passes")
            .takes_value(true)
            .default_value("3"))
        .arg(Arg::with_name("verify")
            .short("v")
            .long("verify"))
        .arg(Arg::with_name("zero")
            .short("z")
            .long("zero-fill"))
        .get_matches();

    let file_path = Path::new(matches.value_of("file").unwrap());
    let passes = matches.value_of("passes")
        .unwrap()
        .parse::<u32>()
        .unwrap_or(3);
    let verify = matches.is_present("verify");
    let zero_fill = matches.is_present("zero");

    let scrambler = BioScrambler::new(passes, verify, zero_fill);
    
    match scrambler.shred_file(file_path) {
        Ok(_) => println!("File shredded successfully"),
        Err(e) => eprintln!("Error: {}", e)
    }
}
