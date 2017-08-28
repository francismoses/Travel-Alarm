//
//  ViewController.swift
//  LocationBasedAlarm
//
//  Created by R.M.K.Engineering College on 01/07/17.
//  Copyright © 2017 R.M.K.Engineering College. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import AVFoundation
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate,UNUserNotificationCenterDelegate {
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var mapKit: MKMapView!
    
    @IBAction func stop(_ sender: UIBarButtonItem) {
        audioPlayer.stop()
    }
    
    
    @IBAction func userloc(_ sender: UIBarButtonItem) {
    
        locationAuthStatus()
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        //  let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapKit.setRegion( region , animated: true)
        
    
    }
    
    
    
    
    
    
    
    
    var locationManager = CLLocationManager()
    var currentloc : CLLocation!
    public var lat:Double=0.0
    public var long:Double=0.0
    public var destlat:Double=0.0
    public var destlong:Double=0.0
    
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        
        locationAuthStatus()
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        //  let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,long)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapKit.setRegion( region , animated: true)
        
    
        //print(lat);
        //print(long);
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKit.showsUserLocation = true
        mapKit.showsScale = true
        mapKit.showsPointsOfInterest = true
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopMonitoringSignificantLocationChanges()
      // viewDidAppear(true)
       searchBar.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:  [.alert , .sound , .badge]){
           (bool,Error) in
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            }
            catch{
                print (error)
            }
        }
        catch{
            print(error)
        }
        UNUserNotificationCenter.current().delegate=self
        //source 40.758903, -73.985034
        //dest 40.644274, -73.782506
       
        
        
      /*  let destLocation = CLLocationCoordinate2DMake(40.644274, -73.782506)
     
        let sourcePlacemark = MKPlacemark(coordinate: location)
        let destPlacemark = MKPlacemark(coordinate: destLocation)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response , error in
            
            guard let response = response else{
                if let error = error {
                    print("Something went wrong")
                }
                return
            }
            let route  = response.routes[0]
            self.mapKit.add(route.polyline, level: .aboveRoads)
            let rekt = route.polyline.boundingMapRect
            self.mapKit.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })*/
        
        
        
        /* let annotation = MKPointAnnotation()
         annotation.coordinate = location
         annotation.title = "R.M.K Engineering"
         annotation.subtitle = "our college"*/
        // mapKit.addAnnotation(annotation)
    
        
        
        
    }
    
    /*func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }*/
    
        
 
    
    func locationAuthStatus()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            
            if let loc = locationManager.location
            
            {
                
                currentloc = loc
                lat = currentloc.coordinate.latitude
                long = currentloc.coordinate.longitude
                
            }
            
            
        }
//        else
//        {
//            locationManager.requestWhenInUseAuthorization()
//            locationAuthStatus()
//        }
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil{
                
                let placemark = placemarks?.first
                
                let anno = MKPointAnnotation()
                self.mapKit.removeAnnotations(self.mapKit.annotations)
                self.mapKit.showsUserLocation = true
                anno.coordinate = (placemark?.location?.coordinate)!
                self.destlat = anno.coordinate.latitude;
                self.destlong = anno.coordinate.longitude
                anno.title = self.searchBar.text!
                
                self.mapKit.addAnnotation(anno)
                self.mapKit.selectAnnotation(anno, animated: true)
                let request = MKDirectionsRequest()
                request.source=MKMapItem.forCurrentLocation()
                //request.destination = searchBar.text!
                print("destination address")
                print(self.destlat);
                print(self.destlong);
                
         
                
                let sourceLoc =  CLLocation(latitude:self.lat, longitude:self.long);
                let destLoc = CLLocation(latitude: self.destlat, longitude: self.destlong)
                
                let distanceMeters = sourceLoc.distance(from: destLoc)
                print("distance between source and dest");
                if(distanceMeters < 1000)
                {
                let answer1 = UNNotificationAction(identifier: "ans1", title: "stop", options: UNNotificationActionOptions.foreground)
                
                    let category = UNNotificationCategory(identifier: "my_cat", actions: [answer1], intentIdentifiers: [], options: [])
                    UNUserNotificationCenter.current().setNotificationCategories([category])
                let  first = UNMutableNotificationContent()
                first.title = "Reached Destination"
                first.subtitle = "time for depart"
                first.body = "hai dude u have reached the dest"
                first.categoryIdentifier = "my_cat"
                first.badge = 1
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10 , repeats: false)
                let request = UNNotificationRequest(identifier: "notyingg", content: first, trigger: trigger)
                UNUserNotificationCenter.current().add(request,  withCompletionHandler: nil)
                    self.audioPlayer.play()
                    
                }
                else{
                    self.audioPlayer.stop()
                }
        
            }
            else{
                
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "ans1"
        {
            self.audioPlayer.stop()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


