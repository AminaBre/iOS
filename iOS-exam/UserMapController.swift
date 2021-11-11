//
//  UserMapController.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 27/10/2021.
//

import MapKit
import UIKit

class UserMapController: UIViewController{
    
    var user:Result?
    
    @IBOutlet var userMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show pin on map
        let userLocation = MKPointAnnotation()
        let userLatitude = NumberFormatter().number(from: user!.location.coordinates.latitude)?.doubleValue
        let userLongitude = NumberFormatter().number(from: user!.location.coordinates.longitude)?.doubleValue
        
        
        userLocation.coordinate = CLLocationCoordinate2DMake(userLatitude!, userLongitude!)
        userLocation.title = "User location"
        userMapView.setCenter(userLocation.coordinate, animated: true)
        userMapView.showAnnotations([userLocation,], animated: true)

        //Getter bildet på nytt
        let url = URL(string: (user?.picture.thumbnail)!)!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
                URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    
}
