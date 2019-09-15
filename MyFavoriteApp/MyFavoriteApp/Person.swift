//
//  Person.swift
//  MyFavoriteApp
//
//  Created by Leah Cluff on 9/3/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation

//Reasoning for this lesson. Before apple introduced Codable to swift Developers had to 

//Using a struct because we want to create memberwise initializer
struct Person {
    let name: String
    let favoriteApp: String
}

//keep the memberwise initializer and also blank initializer by using an extension
extension Person {
    //failable initializer
    init?(dict: [String: Any]) {
        //generic style with FI, cast the code as String. Decode from dictionary
        guard let name = dict["name"] as? String,
            let favoriteApp = dict["favoriteApp"] as? String else {return nil}
        self.name = name
        self.favoriteApp = favoriteApp
    }
    //creating a json dictionary with a value of string any, this is the standard for creating dictionaries just because of the different values you can pull. It would be possible to also use a string: string dictionary as well, this is just better development practice.
    var asJSONDictionary: [String: Any] {
        return ["name": self.name, "favoriteApp" : self.favoriteApp]
    }
    
    var asData: Data? {
        //option click on pretty printed to explain how we want the data to be displayed in JSON
        return (try? JSONSerialization.data(withJSONObject: asJSONDictionary, options: .prettyPrinted))
        
    }
}
