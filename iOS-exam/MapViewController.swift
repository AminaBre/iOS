//
//  MapViewController.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 27/10/2021.
//
import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var users = [Result]()
    
    
    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
    
        for user in users {
            print(user)
            addCustomPin(user: user)
        }
        mapView.delegate = self
                    
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
                URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    
    //Funksjon i en klasse. Klassen er MapviewController.
    private func addCustomPin(user: Result) {
        
        let coordinates = CLLocationCoordinate2D(
            latitude:  Double(user.location.coordinates.latitude)!,
            longitude: Double(user.location.coordinates.longitude)!
        )
        //Er en variabel inni funksjonen addCustomPin. Scopet til denne variabelen er altså BARE selve funksjonen.
        let pin = Pin(title: user.name.first, subtitle: "Some user information", coordinate: coordinates)
        
        pin.user = user
        
        let url = URL(string: (user.picture.thumbnail))!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            pin.image = UIImage(data: data)
        }
        mapView.addAnnotation(pin)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            let identifier = "identifier"
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.image = annotation.image //add this
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            return annotationView
        }
        return nil
    }
    //Gjør slik at UserViewController for valgt annotation dukker opp
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as! Pin
        //Har lagt user inn i CustomAnnotation (Pin), så vi kan hente på den ved bruk av pinen. (pin)
        self.performSegue(withIdentifier: "ShowUserViewController", sender: pin.user)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserViewController {
            destination.user = sender as? Result
        }
    }
    
}
