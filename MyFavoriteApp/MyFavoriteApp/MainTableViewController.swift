//
//  MainTableViewController.swift
//  MyFavoriteApp
//
//  Created by Leah Cluff on 9/3/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var appNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.getPeople { (success) in
            if success {
                //placing this beautiful piece of code to push everything to the main screen and not in the back end. No hiding these lovely people
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
            let favoriteApp = appNameTextField.text, favoriteApp != "" else {
                return
        }
        PersonController.postPerson(name: name, favoriteApp: favoriteApp) { (success) in
            if success {
                DispatchQueue.main.async {
                self.tableView.reloadData()
                self.nameTextField.text = ""
                    self.appNameTextField.text = ""
                }
            } else {
                //Tell the person the user did not send the person to firebase
            }
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //we don't know how many rows we need to have so instead of a set amount, we are making sure that however many people are, they each have their own rows.
        return PersonController.sharedInstance.people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //don't forget to copy and paste the reuse identifier from your storyboard so that there aren't any typo issues.
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let person = PersonController.sharedInstance.people[indexPath.row]
        
        //setting up the information that needs to be displayed on the cell.
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.favoriteApp
        // Configure the cell...
        
        return cell
    }
    
}
