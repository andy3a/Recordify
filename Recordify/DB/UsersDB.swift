//
//  Users.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import Foundation
import Firebase
import CoreMedia

class UsersDB {
    static let usersDB = UsersDB()
    static let db = Firestore.firestore()
    static var currentUser: UsersDBItem?
    
    private init() {
        
    }
    
    static var avatar: ImageAttributes?
    
//    static func writeUser(email: String, role: UserRole, uid: String) {
//        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "email": email,
//            "role": role.rawValue,
//            "uid": uid,
//            "userName": "",
//            "userSurname": ""
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//    }
    
    static func writeUser(email: String, role: UserRole, uid: String) {
        db.collection("users").document(uid).setData([
            "email": email,
            "role": role.rawValue,
            "uid": uid
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(uid)")
            }
        }
    }
    
    static func getCurrentUserRole(completion: @escaping ((String?) -> Void))  {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        getSavedUser { error in
            if let error = error {
                let currentRole = UsersDB.db.collection("users").whereField("uid", isEqualTo: currentUID)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                            completion("Error getting documents: \(err)")
                            
                        } else {
                            for document in querySnapshot!.documents {
                                let recievedData = document.data()
                                
                                let tempCurrentUser = UsersDBItem(
                                    role: recievedData["role"] as! UserRole.RawValue,
                                    email: recievedData["email"] as! String,
                                    uid: recievedData["uid"] as! String
                                )
                                UsersDB.currentUser = tempCurrentUser
                                print(UsersDB.currentUser!)
                                saveCurrentUserLocally()
                                completion(nil)
                            }
                        }
                        
                    }
            } else {
                completion(nil)
            }
        }
        
        
    }
    
    static func saveCurrentUserLocally() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(UsersDB.currentUser) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CurrentUser")
        }
    }
    
    static func getSavedUser(completion: @escaping (String?)-> Void) {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "CurrentUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UsersDBItem.self, from: savedPerson) {
                UsersDB.currentUser = loadedPerson
                completion(nil)
                return
            }
            completion("User cannot be decoded")
            return
        }
        completion("User cannot be found")
        return
    }
    
//    static func deleteLocalUser() {
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey:"CurrentUser")
//    }
    
    static func logOutUser(completion: @escaping() -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //deleteLocalUser()
            UsersDB.removeAllDataFromUserDefaults()
            
            completion()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func getUserFromFirebase(completion: @escaping(UsersDBItem?) -> ()) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        UsersDB.db.collection("users").whereField("uid", isEqualTo: currentUID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                    
                } else {
                    for document in querySnapshot!.documents {
                        let recievedData = document.data()
                        
                        let tempCurrentUser = UsersDBItem(
                            role: recievedData["role"] as! UserRole.RawValue,
                            email: recievedData["email"] as! String,
                            uid: recievedData["uid"] as! String,
                            userName: recievedData["userName"] as? String
                        )
                        
                        completion(tempCurrentUser)
                    }
                }
                
            }
    }
    
    static func updateUserData(key: UserData, value: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        db.collection("users").document(currentUID).setData(
            [
                key.rawValue: value,
            ], merge: true)
        
    }
    
    static func removeAllDataFromUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    static func getAvatarAttributesFromFirebase(completion: @escaping(FirebaseImageAttributes?) -> ()) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        UsersDB.db.collection("users").whereField("uid", isEqualTo: currentUID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                    
                } else {
                    for document in querySnapshot!.documents {
                        let recievedData = document.data()
                        
                        if let avatarOriginalURLstring = recievedData["avatarURL_original"] as? String,
                           let avatarCroppedURLstring = recievedData["avatarURL_cropped"] as? String,
                           let scale = recievedData["scale"],
                           let xWidth = recievedData["xWidth"],
                           let yHeight = recievedData["yHeight"] {
                            
                            guard let avatarURL_original = URL(string: avatarOriginalURLstring)
                            else {
                                completion(nil)
                                return }
                            
                            guard let avatarURL_cropped = URL(string: avatarCroppedURLstring)
                            else {
                                completion(nil)
                                return }
                            
                            let scaleFloat = CGFloat(scale as? Double ?? 1.0)
                            let xWidthFloat = CGFloat(xWidth as? Double ?? 1.0)
                            let yHeightFloat = CGFloat(yHeight as? Double ?? 1.0)
                            
                            let recievedFirebaseImageAttributes = FirebaseImageAttributes(avatarURL_original: avatarURL_original, avatarURL_cropped: avatarURL_cropped, scale: scaleFloat, xWidth: xWidthFloat, yHeight: yHeightFloat)
                            
                            completion(recievedFirebaseImageAttributes)
                        }

                        else {
                            completion(nil)
                            return }
                       
                        
                        
                       
                    }
                }
                
            }
    }
}


