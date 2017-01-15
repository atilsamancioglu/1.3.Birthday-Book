//
//  createFriendVC.swift
//  Birthday Book
//
//  Created by Atıl Samancıoğlu on 11/12/2016.
//  Copyright © 2016 Atıl Samancıoğlu. All rights reserved.
//

import UIKit
import CoreData

class createFriendVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var birthdayText: UITextField!
    
    var chosenFriend = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layoutIfNeeded()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createFriendVC.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        if chosenFriend != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenFriend)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let name = result.value(forKey: "name") as? String {
                                nameText.text = name
                        }
                        
                        if let birthday = result.value(forKey: "birthday") as? String {
                                birthdayText.text = birthday
                        }
                        
                        if let age = result.value(forKey: "age") as? Int {
                                ageText.text = String(age)
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                                self.imageView.image = image
                        }
                        
                    }
                    
                }
                
                
            } catch {
                print("an error occured")
            }

            
        }
        
        
        
    }
    
    func selectImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friends", into: context)
        
        newFriend.setValue(nameText.text, forKey: "name")
        newFriend.setValue(Int(ageText.text!)!, forKey: "age")
        newFriend.setValue(birthdayText.text, forKey: "birthday")
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        newFriend.setValue(data, forKey: "image")
        
        do {
            
            try context.save()
            print("we managed to save the friend")
            
        } catch {
            
            print("an error occured!")
            
        }
     
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"friendcreated"), object: nil)
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
 
}
