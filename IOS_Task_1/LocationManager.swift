import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var userSide: String? = nil
    @Published var locationReady = false
    
    // The designated middle longitude
    let midLongitude: Double = 34.817549168324334
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if location.coordinate.longitude > midLongitude {
            userSide = "East Side"
        } else {
            userSide = "West Side"
        }
        
        locationReady = true
        manager.stopUpdatingLocation()
    }
}
