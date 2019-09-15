
//
//  PersonController.swift
//  MyFavoriteApp
//
//  Created by Leah Cluff on 9/3/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation

class PersonController {
    //using a singleton to access the person controller from other swift files.
    static let sharedInstance = PersonController()
    
    //creating your SOURCE OF TRUTH! Access that data model bb
    var people: [Person] = []
    
    //Creating the base url without. Doing this gives you the base for your API calls
    //API stands for Application programming interface
    static let baseURL = URL(string: "https://myfavoriteapp-733d2.firebaseio.com")
    
    //using a bool to determine if the completion block
    static func getPeople(completion: @escaping ((Bool) -> Void)) {
        
        //path components are dashes. extensions are dots
        let fullURL = baseURL?.appendingPathComponent("People")
        guard let fullURLAsJSON = fullURL?.appendingPathExtension("json") else {
            completion(false)
            return
        }
        //once the url is built out, we must use a url request for GETTING the information
        var request = URLRequest(url: fullURLAsJSON)
        //think of method and body that go with the url request
        request.httpMethod = "GET"
        request.httpBody = nil
        
        //time to create a dataTask, doing this helps you pull the data from your url
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error getting people from the web \(error.localizedDescription), \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("There was no data")
                completion(false)
                return
            }
            
            //option click on .allow fragments so that they understand how the data is parsed.
            
            //Why are we unwrapping everything? Because playing fast and furious with your code can result in a lot of errors down the road that you will spend a LONG time debugging
            guard let jsonDictionaries = (try?  JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [String: Any]]) else {
                print("JSON Data was not converted into expected format")
                completion(false)
                return
            }
            //placing an additional source of truth so that when you create a new person, you have a dictionary value, then appending the new person.
            //by doing this you are adding a new element of data to your collection
            var people: [Person] = []
            for dict in jsonDictionaries {
                if let newPerson = Person(dict: dict.value) {
                    people.append(newPerson)
                    
                }
            }
            PersonController.sharedInstance.people = people
            completion(true)
        }
        
        
        //Always print out the url in web browser to make sure it works
        print(fullURLAsJSON.absoluteString)
        //don't forget .resume! Everyone including myself does and it will cause your code to not run and your app won't work
        dataTask.resume()
        return
        
    }
    //Same thing as above but instead of pulling information from firebase, we are pushing it up to our super duper neat realtime cloud database
    
    static func postPerson(name: String, favoriteApp: String, completion: @escaping ((Bool) -> Void)) {
        guard let fullURL = baseURL?.appendingPathComponent("People").appendingPathExtension("json") else {
            //always use print statements so you have a better understanding of what's happening in your code. By using these print statements, especially with network calls, debugging gets a lot easier. Always be safe when programming!
            print("error pulling URL")
            completion(false)
            return
        }
        
        print(fullURL.absoluteString)
        //Using the MEMBERwise initializer
        let newPerson = Person(name: name, favoriteApp: favoriteApp)
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.httpBody = newPerson.asData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("error posting to Firebase: \(error.localizedDescription), \(error)")
                completion(false)
                return
            }
            guard data != nil else {
                print("No data was received")
                completion(false)
                return
            }
            print("Success! User was posted to firebase!")
            PersonController.sharedInstance.people.append(newPerson)
            completion(true)
        }
        dataTask.resume()
        return
    }
}
