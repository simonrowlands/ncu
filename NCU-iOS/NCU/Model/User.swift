//
//  User.swift
//  NCU
//
//  Created by Simon Rowlands on 13/11/2018.
//  Copyright © 2018 simonrowlands. All rights reserved.
//

import Foundation

import GoogleSignIn

final class User: Codable {
    let userID: String
    let idToken: String
    let fullName: String
    let givenName: String
    let familyName: String
    let email: String
    var office: Office?
    
    init(userID: String, idToken: String, fullName: String, givenName: String, familyName: String, email: String, office: Office? = nil) {
        self.userID = userID
        self.idToken = idToken
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.office = office
    }
    
    func store() { // This is until we know what data we need/where to store
        do {
            let encodedData = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encodedData, forKey: "userData")
        } catch {
            debugPrint("Failed to encode user data! \(error.localizedDescription)")
        }
    }
    
    static func get() -> User? {
        
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? Data else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(User.self, from: userData)
        } catch {
            debugPrint("Failed to decode/retrieve user data! \(error.localizedDescription)")
        }
        return nil
    }
}

extension User {
    
    static func create(from googleUser: GIDGoogleUser) -> User {
        return User(userID: googleUser.userID, idToken: googleUser.authentication.idToken, fullName: googleUser.profile.name, givenName: googleUser.profile.givenName, familyName: googleUser.profile.familyName, email: googleUser.profile.email)
    }
    
//    static func get() -> User? {
//        guard let googleUser = GIDSignIn.sharedInstance()?.currentUser else {
//            return nil
//        }
//        return User.create(from: googleUser)
//    }
}