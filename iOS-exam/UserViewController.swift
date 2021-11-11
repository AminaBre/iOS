//
//  UserViewController.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 21/10/2021.
//

import UIKit

class UserViewController: UIViewController {

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
    //Knapp tilhørende kart
    @IBAction func onClick(_ sender: UIButton) {performSegue(withIdentifier: "UserMapSegue", sender: self)
    }
    
    //Knapp tilhørende rediger
    @IBAction func onClickEditUser(_ sender: UIButton) {
        performSegue(withIdentifier: "EditUserViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserMapSegue" {
            let destination = segue.destination as? UserMapController
            destination?.user = user
        } else if segue.identifier == "EditUserViewSegue" {
            let destination = segue.destination as? EditUserViewController
            destination?.user = user
        }
    }
    
    
}
