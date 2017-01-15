//
//  ViewController.swift
//  Birthday Book
//
//  Created by Atıl Samancıoğlu on 11/12/2016.
//  Copyright © 2016 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var ageArray = [Int]()
    var birthdayArray = [String]()
    var imageArray = [UIImage]()
    var selectedFriend = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
  
        retrieveInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.retrieveInfo), name: NSNotification.Name(rawValue:"friendcreated"), object: nil)
    }
    
    func retrieveInfo() {
        
        self.nameArray.removeAll(keepingCapacity: false)
        self.ageArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        self.birthdayArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    
                    if let birthday = result.value(forKey: "birthday") as? String {
                        self.birthdayArray.append(birthday)
                    }
                    
                    if let age = result.value(forKey: "age") as? Int {
                        self.ageArray.append(age)
                    }
                    
                    if let imageData = result.value(forKey: "image") as? Data {
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
            
        } catch {
            print("an error occured")
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedFriend = nameArray[indexPath.row]
        performSegue(withIdentifier: "createFriendSegue", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFriendSegue" {
            let destinationVC = segue.destination as! createFriendVC
            destinationVC.chosenFriend = selectedFriend
        }
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "createFriendSegue", sender: nil)
        
    }
    
    
    

}

