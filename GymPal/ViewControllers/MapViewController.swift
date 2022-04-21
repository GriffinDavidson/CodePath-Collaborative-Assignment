//
//  MapViewController.swift
//  GymPal
//
//  Created by Spencer Steggell on 4/13/22.
//

import UIKit
import Parse
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gymMapView: MKMapView!

    @IBOutlet weak var gymsTableView: UITableView!
    
    
    var gymArray: [Gyms] = []
    var gymPins = [MKPointAnnotation]()

    // Setting Default location to San Francisco
    let defaultCoordinate = CLLocation(latitude: 37.773972, longitude: -122.431297)
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        gymMapView.delegate = self
        gymsTableView.dataSource = self
        gymsTableView.delegate = self
        
        print("User's Location is: \(locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297))")
        self.gymsTableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        findCurrentLocation()
        centerMap()
        loadGyms()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView: MKMarkerAnnotationView
        if let annotationView = gymMapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKMarkerAnnotationView {
            pinView = annotationView
        } else {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        }

        //annotation = gymArray[coordinates]

    
        //gymAnnotation.coordinate = gymArray[].coordinates

        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView.annotation = annotation
        return pinView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymArray.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymCellTableViewCell", for: indexPath) as! GymCellTableViewCell
        
        
        cell.gymName.text = gymArray[indexPath.row].name
      //  cell.ratingLabel.text = String(venues[indexPath.row].rating ?? 0.0)
        //cell.priceLabel.text = venues[indexPath.row].price ?? "-"
       // cell.isClosed = venues[indexPath.row].is_closed ?? false
        cell.gymAddress.text = gymArray[indexPath.row].address
        
        return cell
    }
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    
    
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        print("User Logged out")
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let
                delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
        
    }
    
    func findCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
      //  gymMapView.showsUserLocation = true
        
        
    }
    
    func centerMap() {
        
        let location = locationManager.location
        let defaultLat = 37.773972
        let defaultLong = -122.431297
        let defaultCoordinate = CLLocationCoordinate2D(latitude: defaultLat, longitude: defaultLong)
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let mapRegion = MKCoordinateRegion(center: location?.coordinate ?? defaultCoordinate, span: span)
        gymMapView.setRegion(mapRegion, animated: true)
    }



    func loadGyms() {

//        if locationManager.location == nil {
//            print("cannot pull location")
//            let location = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
//        }
        let location = locationManager.location ?? defaultCoordinate
        print("Loading gyms")
        retrieveGyms(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, category: "gyms", limit: 20, sortBy: "distance", locale: "en_US") { (response, error) in
            if let response = response {
                print("received a response")
                print(response)
                
                self.gymArray = response
                DispatchQueue.main.async {
                    self.gymsTableView.reloadData()
                    self.gymMapView.addAnnotations(self.gymPins)
                    print("Dispatching gym pins: \(self.gymPins)")
                }
            }
                
            
            
        }
    }

    
    
  
        
       // var gymMapView = MapViewController.mapView
       
        
        
        // MARK: URL Function
        func retrieveGyms(latitude: Double, longitude: Double, category: String, limit: Int, sortBy: String, locale: String, completionHanlder: @escaping ([Gyms]?, Error?) -> Void) {
            
        let apikey = Yelp_API
        
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
                   //  "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
            
            let url = URL(string: baseURL)
            var request = URLRequest(url:url!)
            request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completionHanlder(nil, error)
                    print("error loading: \(error.localizedDescription)")
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[])
                    guard let resp = json as? NSDictionary else { return }

                    guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                    print("returning businesses")
                    //print(businesses)

                    var gymsList: [Gyms] = []
                    self.gymPins = []

                    for business in businesses {
                        var gyms = Gyms()
                        
                        let annotation = MKPointAnnotation()
                        gyms.name = business.value(forKey: "name") as? String
                        //gyms.coordinates = business.value(forKey: "coordinates") as? [String]
                        gyms.longitude = business.value(forKeyPath: "coordinates.longitude") as? Double
                        gyms.latitude = business.value(forKeyPath: "coordinates.latitude") as? Double
                        let address = business.value(forKeyPath: "location.display_address") as? [String]
                        gyms.address = address?.joined(separator: "\n")
                        let coordinates = CLLocationCoordinate2D(latitude: gyms.latitude!, longitude: gyms.longitude!)
                        gyms.coordinates = coordinates
                        annotation.coordinate = coordinates
                        annotation.title = gyms.name
                        gymsList.append(gyms)
                        self.gymPins.append(annotation)
                        print(self.gymPins)
                    }
                    
                    completionHanlder(gymsList, nil)
                    
                } catch {
                    print("Caught Error: \(error.localizedDescription)")
                }
                
            } .resume()
            
        }
    
}

