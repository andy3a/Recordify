//
//  Users.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import Foundation
import Firebase

class UsersDB {
    static let usersDB = UsersDB()
    static let db = Firestore.firestore()
    static var currentUser: UsersDBItem?
    
    private init() {
        
    }
    
    static func writeUser(email: String, role: UserRole, uid: String) {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "email": email,
            "role": role.rawValue,
            "uid": uid
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    static func getCurrentUserRole(completion: @escaping (() -> Void))  {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        let currentRole = db.collection("users").whereField("uid", isEqualTo: currentUID)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completion()
                        
                    } else {
                        for document in querySnapshot!.documents {
                            let recievedData = document.data()
                           
                            let tempCurrentUser = UsersDBItem(
                                role: recievedData["role"] as! UserRole.RawValue,
                                email: recievedData["email"] as! String,
                                uid: recievedData["uid"] as! String
                            )
                            currentUser = tempCurrentUser
                            print(currentUser!)
                            completion()
                        }
                    }
            }
    }
}


