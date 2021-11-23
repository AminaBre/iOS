//
//  ViewController.swift
//  iOS-exam
//
//  Created by Amina Brenneng on 21/10/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Setter users til å være et array av Result
    var users = [Result]()
    var dbUsers = [User]()
    //Kopler opp  mot databasen
    
    let database = DatabaseHandler.shared
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Hvis API'et blir laster riktig..
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON {
        print("JSON fungerer!")
        self.tableView.reloadData()
            
            self.dbUsers = self.database.fetch(User.self)

            for user in self.dbUsers {
                print("fname: ", user.first_name)
            }
            
        //Get items from corecata
        fetchUsers()
    }
        
        func fetchUsers() {
            
            //Fetching data from coredata and displaying in tableview
            do {
                self.dbUsers = try context.fetch(User.fetchRequest())
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            catch{
                
            }
        }
        
    func viewWillAppear(_ animated: Bool) {
        dbUsers = database.fetch(User.self)
    }
     
        //Sender UserInfo fra UserTableViewCell til hver enkelt celle i UserTableView
        
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let viewControllers = self.tabBarController?.viewControllers
        let svc = (viewControllers![1] as! UINavigationController).viewControllers[0] as! MapViewController
        sleep(5)
        svc.users = users
    }
    
    //Returnerer antall brukere i users, som er et array av Results. (100 stk)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbUsers.count;
    }
    
    //Fyller tableView med ønsket data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        let user = self.dbUsers[indexPath.row]
        
        cell.userName.text = user.first_name
        
        /*cell.userName.text = users[indexPath.row].name.first + " " + users[indexPath.row].name.last
        let url = URL(string: users[indexPath.row].picture.thumbnail)!
        getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() { [weak self] in
        cell.userImageView.image = UIImage(data: data)
            }
        }*/
        
        
        return cell
        
    }
    
    //Setter at showDetails (linken mellom hver row og ny side) skal ta oss til nytt view tilhørende valgt user
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserViewController {
            destination.user = users[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    //Laster ned API'et, med error dersom det failer.
    
    func downloadJSON(completed: @escaping () -> Void) {
        let url = URL(string: "https://randomuser.me/api/?results=100" )!
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("get error: ", error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    print("http response not between 200-299: ", error)
                    return
                }
            do{
                self.users = try! JSONDecoder().decode(UserInfo.self, from: data!).results
                
                for user in self.users {
                    user.store()
                }
                DispatchQueue.main.async {
                        completed()
                    
                    }
            }
                
        }.resume()
    }

}

