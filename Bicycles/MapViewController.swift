//
//  MapViewController.swift
//  Bicycles
//
//  Created by Andrew D Lee on 8/30/16.
//  Copyright © 2016 Andrew D Lee. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration

// This class allows the user to search for Bikes-related businesses from either
// their current location or from a searched location.
// This class is largely based on https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var searchController: UISearchController?
    var searchCurrentLocationButton: UIBarButtonItem?
    let locationManager = CLLocationManager()
    
    // MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the default map region
        
        addSearchCurrentLocationButton()
        setSearchControllerProperties()
        setLocationManagerProperties()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.networkConnectionDelegate = self
    }

    override func viewWillAppear(animated: Bool) {
        if !connectedToNetwork() {
            displayNetworkErrorMessage()
            disableSearchControls()
        }
        else {
            enableSearchControls()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        addApplicationDidBecomeActiveNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controls
    
    // based on http://stackoverflow.com/a/33861637/3113924
    /// Adds SearchCurrentLocation button to navigation bar.
    /// - Returns: Void
    func addSearchCurrentLocationButton() {
        searchCurrentLocationButton = UIBarButtonItem(
            image: UIImage(named: "currentLocationIcon"),
            style: .Plain,
            target: self,
            action: #selector(searchCurrentLocationButtonTapped))

        self.navigationItem.rightBarButtonItem = searchCurrentLocationButton
    }
    
    /// Action for SearchCurrentLocationButton. Searches near the user's current location
    /// for Bikes-related businesses. Informs the user if there is a problem with
    /// Location Services that would prevent search.
    /// - Returns: Void
    func searchCurrentLocationButtonTapped() {
        if CLLocationManager.locationServicesEnabled() {
            print("Location Services enabled")
            if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
                print("Application not authorized to use Location Services")
                
                let title = "Location Services Not Authorized!"
                let message = "You have not authorized this application to use Location Services. Please enable Locations Services for this application in  Setings > Bicycles > Location."
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
        }
        else {
            print("Location Services disabled")
            let title = "Location Services Disabled!"
            let message = "Location Services are not enabled on your device. Please enable Location Services in the Settings > Privacy menu before attempting to use this feature."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        print("Location Services enabled and authorized")
        
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        searchLocation(placemark)
    }
    
    /// Adds sets properties of UISearchController.
    /// - Returns: Void
    func setSearchControllerProperties() {
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier("SearchResults") as! SearchResultsTableViewController
        
        searchController = UISearchController(
            searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = searchResultsController
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.obscuresBackgroundDuringPresentation = true
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Search for place or address"
        searchController?.delegate = self
        
        searchResultsController.mapView = self.mapView
        searchResultsController.searchLocationDelegate = self
        searchResultsController.networkConnectionDelegate = self
        
        self.navigationItem.titleView = searchController?.searchBar
        self.definesPresentationContext = true
    }
    
    // MARK: - Helper Functions
    
    /// Sets properties of locationManager
    /// - Returns: Void
    func setLocationManagerProperties() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - SearchLocationDelegate Protocol

protocol SearchLocationDelegate : class {
    func searchLocation(placemark: MKPlacemark) -> Void
}

// MARK: - NetworkConnectionDelegate Protocol

protocol NetworkConnectionDelegate : class {
    func disableSearchControls() -> Void
    
    func enableSearchControls() -> Void
    
    func displayNetworkErrorMessage() -> Void
    
    func connectedToNetwork() -> Bool
}

// MARK: - NetworkConnectionDelegate Extension

extension MapViewController : NetworkConnectionDelegate {
    /// Disables the search controls and deactivates the UISearchController.
    /// - Returns: Void
    func disableSearchControls() {
        print("Disabling search controls")
        
        self.searchController?.active = false
        self.navigationItem.titleView?.userInteractionEnabled = false
        self.searchCurrentLocationButton?.enabled = false
    }
    
    /// Enables the search controls.
    /// - Returns: Void
    func enableSearchControls() {
        print("Enabling search controls")
        
        self.navigationItem.titleView?.userInteractionEnabled = true
        self.searchCurrentLocationButton?.enabled = true
    }
    
    /// Displays the network error message.
    /// - Returns: Void
    func displayNetworkErrorMessage() {
        print("Network error/Network unavailable")
        
        let title = "Network Error!"
        let message = "Your device does not have a network connection. Please connect your device to a network to use the Maps feature of this application."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // from http://stackoverflow.com/a/25623647/3113924
    /// Tests for network connectivity.
    /// - Returns: true if network available, false otherwise
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        
        return (isReachable && !needsConnection)
    }

}

// MARK: - SearchLocationDelegate Extension

extension MapViewController : SearchLocationDelegate {
    /// Sets the parameters of the search before executing the search.
    /// - Parameter placemark: MKPlacemark representing the center of the search region.
    /// - Returns: Void
    func searchLocation(placemark: MKPlacemark) {
        let coordinate = placemark.coordinate
        
        print("Searching for Bikes-related businesses at \(coordinate)")
        
        // set the approximate search region to size of 20 km x 20 km
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 20000, 20000)
        
        searchRegion(region)
    }
    
    /// Sets the parameters of the search before executing the search and also adds
    /// an annotation to the map view.
    /// - Note: Primarily used for testing purposes.
    /// - Parameter placemark: MKPlacemark representing the center of the search region.
    /// - Returns: Void
    func searchLocationWithAnnotation(placemark: MKPlacemark) {
        addSearchLocationAnnotation(placemark)
        searchLocation(placemark)
    }
    
    /// Adds annotation to the map view at the specified placemark.
    /// - Parameter placemark: MKPLacemark representing the location for the annotation.
    /// - Returns: Void
    func addSearchLocationAnnotation(placemark: MKPlacemark) {
        // remove existing annotations
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        // assign properties of the annotation for this placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality, state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        // add the annotation to the mapview
        self.mapView.addAnnotation(annotation)
    }
    
    /// Searches the given region for Bikes-related businesses through a
    /// MKLocalSearch request.
    /// - Parameter region: MKCoordinateRegion representing the area to search.
    /// - Returns: Void
    func searchRegion(region: MKCoordinateRegion) {
        let request = MKLocalSearchRequest()
        // search for results related to bikes
        request.naturalLanguageQuery = "Bikes"
        request.region = region
        
        print("Searching for Bikes")
        
        // asynchronously conduct the search
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        MKLocalSearch(request: request).startWithCompletionHandler {
            (response, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            guard error == nil else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print(error)
                
                let title = "Error!"
                let message = "A newtork error may have occurred. Please check your network connection and try again."
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                self.navigationItem.titleView?.userInteractionEnabled = false
                self.searchCurrentLocationButton?.enabled = false
                
                return
            }
            guard let response = response else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                return
            }
            guard response.mapItems.count > 0 else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                print("0 results found")
                
                let title = "No results!"
                let message = "Your query did not return any results."
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                return
            }
            
            print("\(response.mapItems.count) results found")
            
            for location in response.mapItems {
                print("Name = \(location.name)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.placemark.coordinate
                annotation.title = location.name
                self.mapView.addAnnotation(annotation)
            }
            
            self.mapView.setRegion(region, animated: true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

// MARK: - UISearchControllerDelegate Extension

extension MapViewController : UISearchControllerDelegate {
    func willPresentSearchController(searchController: UISearchController) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.rightBarButtonItem = searchCurrentLocationButton
    }
}

// MARK: - CLLocationManagerDelegate Extension

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        if error.code == 1 {
            // user has denied use of Location Services so do not request updates
            locationManager.stopUpdatingLocation()
        }
    }
}


