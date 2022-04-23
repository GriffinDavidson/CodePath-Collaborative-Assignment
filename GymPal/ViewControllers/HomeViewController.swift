//
//  HomeViewController.swift
//  GymPal
//
//  Created by Griffin Davidson on 4/14/22.
//

import UIKit
import MapKit
import Parse
import AlamofireImage

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let defaultLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
    let defaultLocationCoordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
    
    var gymArray: [Gyms] = []
    var gymPins = [MKPointAnnotation]()
    
    var users = [PFObject]()
    
    {
        didSet
        {
            peopleCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "GymPal"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        peopleCollectionView.delegate = self
        peopleCollectionView.dataSource = self

        
        // Do any additional setup after loading the view.
        
//        let layout = peopleCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 0
//
//        let width = (view.frame.width - layout.minimumInteritemSpacing * 2) / 2
//        layout.itemSize = CGSize(width: width, height: 3 / 2 * width)
        
        map.delegate = self
        
        let center: CLLocationCoordinate2D? = nil
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center ?? defaultLocationCoordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        findCurrentLocation()
        centerMap()
        loadGyms()
        loadUsers()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let user = users[indexPath.row]
        
        
        if (indexPath.row < users.count && indexPath.row < 7)
        {
            guard let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCollectionViewCell", for: indexPath) as? PeopleCollectionViewCell
            else
            {
                print("Error! Returned Normal Cell!")
                return UICollectionViewCell()
            }
            
            let name =  "\(user["firstName"]!) \(user["lastName"]!)"
            
            let imageFile = user["profilePicture"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.image.af.setImage(withURL: url)
            
            
            cell.nameLabel.text = name
            
            return cell
        }
        else
        {
            guard let cell = peopleCollectionView.dequeueReusableCell(withReuseIdentifier: "ToFullPeopleCollectionViewCell", for: indexPath) as? ToFullPeopleCollectionViewCell
            else
            {
                print("Error! Returned Normal Cell! (Load More Cell)")
                return UICollectionViewCell()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (users.count > 8 ? 8 : users.count)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            map.setRegion(mapRegion, animated: true)
        }
    
    func loadGyms() {

    //        if locationManager.location == nil {
    //            print("cannot pull location")
    //            let location = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
    //        }
            let location = locationManager.location ?? defaultLocation
            print("Loading gyms")
            retrieveGyms(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, category: "gyms", limit: 20, sortBy: "distance", locale: "en_US") { (response, error) in
                if let response = response {
                    print("received a response")
                    print(response)
                    
                    DispatchQueue.main.async {
                        self.map.addAnnotations(self.gymPins)
                        print("Dispatching gym pins: \(self.gymPins)")
                    }
                }
                    
                
                
            }
        }
    
    func retrieveGyms(latitude: Double, longitude: Double, category: String, limit: Int, sortBy: String, locale: String, completionHanlder: @escaping ([Gyms]?, Error?) -> Void) {
                
            let apikey = "some key"
            
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
    
    func loadUsers()
    {
        let query = PFQuery(className: "Profiles")
        query.includeKeys(["lastName",
                           "prefferedGym",
                           "about",
                           "pronouns",
                           "profilePicture",
                           "userName",
                           "firstName",
                           "age"])
        query.limit = 20
        
        query.findObjectsInBackground
        { (users, error) in
            if users != nil
            {
                self.users = users!
                self.peopleCollectionView.reloadData()
            }
        }
    }
}
