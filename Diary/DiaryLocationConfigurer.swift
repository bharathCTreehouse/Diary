//
//  DiaryLocationConfigurer.swift
//  Diary
//
//  Created by Bharath on 17/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreLocation

enum DiaryLocationStatus {
    case noAccess
    case accessRequested
    case accessGranted
    case accessRejected
    case currentLocation (CLLocation)
    case locationError (DiaryLocationError)
}

enum DiaryLocationError {
    case noNetwork
    case unknownLocation
    case unableToFetch
    case unknownError
}


class DiaryLocationConfigurer: NSObject {
    
    var completionHandler: ((DiaryLocationStatus) -> Void)!
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    init(withCompletionHandler handler: @escaping ((DiaryLocationStatus) -> Void)) {
        
        completionHandler = handler
        super.init()
    }
    
    
    func beginLocationFetching() {
        
        locationManager.delegate = self

        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .denied || authStatus == .notDetermined {
            
            completionHandler(DiaryLocationStatus.accessRequested)
            locationManager.requestWhenInUseAuthorization()
        }
        else if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func endLocationFetching() {
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil


    }
    
    
    deinit {
        completionHandler = nil
    }
    
}



extension DiaryLocationConfigurer: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.isEmpty == false {
            completionHandler(DiaryLocationStatus.currentLocation(locations.last!))
        }
        else {
            completionHandler(DiaryLocationStatus.locationError(.unableToFetch))
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let locationError: NSError = error as NSError
        
        if locationError.code == 0 {
            completionHandler(DiaryLocationStatus.locationError(.unknownLocation))
            
        }
        else if locationError.code == 2 {
            completionHandler(DiaryLocationStatus.locationError(.noNetwork))
            
        }
        else {
            completionHandler(DiaryLocationStatus.locationError(.unknownError))
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            beginLocationFetching()
        }
        else if status == .denied {
            
            completionHandler(DiaryLocationStatus.accessRejected)
        }
        
    }

    
}



extension DiaryLocationConfigurer {
    
    static func fetchUserReadableData(fromLocation loc: CLLocation, withCompletionHandler handler: @escaping (([CLPlacemark]?, Error?) -> Void)) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (allPlacemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            handler(allPlacemarks, error)
        })
        
    }
}
