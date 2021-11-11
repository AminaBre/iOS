//
//  EditUserViewController.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 30/10/2021.
//


import UIKit

class EditUserViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCode: UILabel!
    

    var user:Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "Fornavn: " + "\(user!.name.first)" + " " + "\(user!.name.last)"
        ageLabel.text = "Alder: " + "\(user!.dob.age)"
        birthdayLabel.text = "Bursdag: " + "\(user!.dob.date.split(separator: "T")[0])"
        
        emailLabel.text = "Email: " + "\(user!.email)"
        
        cityLabel.text = "By: " + "\(user!.location.city)"
        stateLabel.text = "Fylke: " + "\(user!.location.state)"
        zipCode.text = "Postnummer: " + "\(user!.location.postcode)"
        
        //Getter bildet på nytt
        let url = URL(string: (user?.picture.large)!)!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            
        //Gjør at teksten ikke renderes før bildet
        DispatchQueue.main.async() { [weak self] in
            self!.imageView.image = UIImage(data: data )
            
            }
        }
    }
    
func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
