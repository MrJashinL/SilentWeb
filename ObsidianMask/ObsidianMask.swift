import CoreLocation
import Foundation
import MapKit

let AUTHOR = "Jashin L."

class LocationSpoofer: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var fakeLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startSpoofing(latitude: Double, longitude: Double) {
        fakeLocation = CLLocation(
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: 5,
            timestamp: Date()
        )
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        guard let fakeLocation = fakeLocation else { return }
        locationManager.location = fakeLocation
    }
}

class ObsidianMask {
    private let spoofer = LocationSpoofer()
    
    func setLocation(lat: Double, lon: Double) {
        spoofer.startSpoofing(latitude: lat, longitude: lon)
    }
    
    func randomLocation() {
        let lat = Double.random(in: -90...90)
        let lon = Double.random(in: -180...180)
        setLocation(lat: lat, lon: lon)
    }
    
    func loadLocationFromFile(_ path: String) {
        guard let content = try? String(contentsOfFile: path) else { return }
        let coordinates = content.split(separator: ",")
        if coordinates.count == 2,
           let lat = Double(coordinates[0]),
           let lon = Double(coordinates[1]) {
            setLocation(lat: lat, lon: lon)
        }
    }
    
    func saveCurrentLocation(_ path: String) {
        guard let location = spoofer.locationManager.location else { return }
        let content = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        try? content.write(toFile: path, atomically: true, encoding: .utf8)
    }
}

let args = CommandLine.arguments

if args.count > 1 {
    let mask = ObsidianMask()
    
    switch args[1] {
    case "-s", "--set":
        if args.count == 4 {
            mask.setLocation(lat: Double(args[2])!, lon: Double(args[3])!)
        }
    case "-r", "--random":
        mask.randomLocation()
    case "-l", "--load":
        if args.count == 3 {
            mask.loadLocationFromFile(args[2])
        }
    case "-save":
        if args.count == 3 {
            mask.saveCurrentLocation(args[2])
        }
    default:
        print("Usage:")
        print("-s, --set [lat] [lon]: Set specific location")
        print("-r, --random: Set random location")
        print("-l, --load [file]: Load location from file")
        print("-save [file]: Save current location to file")
    }
    
    RunLoop.main.run()
}
