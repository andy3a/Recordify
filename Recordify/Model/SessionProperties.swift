//
//  SessionProperties.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 8.02.22.
//

import Foundation
import SwiftUI
import Firebase
import Kingfisher

let placeholderImage = ImageAttributes(withSFSymbol: "person.crop.circle.fill")

enum UserData: String {
    case role
    case email
    case uid
    case userName
    case userSurname
}

@propertyWrapper class FirebasePublished {
    var value: String!
    var key: UserData
    private var localStorage: UserDefaults = .standard
    
    var wrappedValue: String  {
        get {
            return value
        }
        set {
            localStorage.set(newValue, forKey: key.rawValue)
            UsersDB.updateUserData(key: key, value: newValue)
            value = newValue
        }
    }
    
    init(key: UserData) {
        self.key = key
        // check if entry in UserDefaults exists
        if let localValue = localStorage.string(forKey: key.rawValue) {
            value = localValue
        } else {
            // check if entry in FireBase exists
            if let _ = Auth.auth().currentUser?.uid {
                UsersDB.getUserFromFirebase { user in
                    self.value = user?.returnRequeredProp(key: key) as? String ?? "User name"
                    self.localStorage.set(user?.returnRequeredProp(key: key) as? String, forKey: key.rawValue)
                }
            }
        }
    }
    
    
}


@propertyWrapper class FirebasePublishedImage {
    var value: ImageAttributes = placeholderImage
    
    private var localStorage: UserDefaults = .standard
    private var fileManager: FileManager = .default
    
    var wrappedValue: ImageAttributes  {
        get {
            return value
        }
        set {
            print("set is triggered")
            self.value = newValue
            guard let original = newValue.originalImage else {return}
            guard let cropped = newValue.croppedImage else {return}
           
            uploadUIImageToFirebase(image: original, imageType: "original", completion: { result in
                print ("\n \n \(String(describing: result))")
                self.saveAttributesToUserData(urlString: result, key: "original", imageAttributes: self.value)
                
            })
            
            uploadUIImageToFirebase(image: cropped, imageType: "cropped", completion: { result in
                print ("\n \n \(String(describing: result))")
                self.saveAttributesToUserData(urlString: result, key: "cropped")
                
            })
            
        }
    }
    
    init() {
        UsersDB.getAvatarAttributesFromFirebase { savedAttributes in
            guard savedAttributes != nil else {
                self.value = placeholderImage
                return }
            
            let original = ImageResource(downloadURL: savedAttributes!.avatarURL_original)
            let cropped = ImageResource(downloadURL: savedAttributes!.avatarURL_cropped)
            
            KingfisherManager.shared.retrieveImage(with: original) { result in
                switch result {
                case .success(let recievedOriginal):
                    KingfisherManager.shared.retrieveImage(with: cropped) { result in
                        switch result {
                        case .success(let recievedCropped):
                            self.value = ImageAttributes(
                                image: Image(uiImage: recievedCropped.image),
                                originalImage: recievedOriginal.image,
                                croppedImage: recievedCropped.image,
                                scale: CGFloat(floatLiteral: CGFloat.NativeType(savedAttributes!.scale)),
                                xWidth:CGFloat(floatLiteral: CGFloat.NativeType(savedAttributes!.xWidth)),
                                yHeight: CGFloat(floatLiteral: CGFloat.NativeType(savedAttributes!.yHeight)))
                        case .failure(let error) :
                            print(error)
                            
                        }
                    }
                case .failure(let error) :
                    print(error)
                    
                }
            }
            
        }
    }
    
    deinit {
        value = placeholderImage
    }
    
    
    
    
    
    
    func saveAttributesToUserData(urlString: String, key:String, imageAttributes: ImageAttributes? = nil) {
        let db = UsersDB.db
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        guard let checkedURL: URL = URL(string: urlString) else {return}
        db.collection("users").document(currentUID).setData(
            [
                "avatarURL_\(key)": checkedURL.absoluteString,
                "scale": imageAttributes?.scale,
                "xWidth": imageAttributes?.xWidth,
                "yHeight": imageAttributes?.yHeight
            ], merge: true)
        
    }
    
    func uploadUIImageToFirebase(image: UIImage, imageType: String, completion: @escaping (String) ->())  {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {
            completion("Error getting user UID")
            return
        }
        
        let data = image.jpegData(compressionQuality: 1.0) ?? Data()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        //let uuid = UUID().uuidString
        let riversRef = storageRef.child("profileImages/\(currentUID)/\(imageType).jpg")
       
       
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                riversRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(error.localizedDescription)
                        return
                    } else {
                        guard let downloadURL = url else {
                            completion("Error getting image URL")
                            return
                        }
                        completion(downloadURL.absoluteString)
                    }
                }
            }
        }
        let _ = uploadTask.observe(.progress) { snapshot in
            print(snapshot.progress ?? 0) // NSProgress object
        }
        
    }
    
}

func uploadToFirebase(image: UIImage) -> String?  {
    var result: String? = nil
    guard let currentUID = Auth.auth().currentUser?.uid else {return "Error getting user UID"}
    
    let data = image.jpegData(compressionQuality: 1.0) ?? Data()
    
    let storage = Storage.storage()
    let storageRef = storage.reference()
    // Create a reference to the file you want to upload
    let uuid = UUID().uuidString
    let riversRef = storageRef.child("profileImages/\(currentUID)/avatar.jpg")
    
    // Upload the file to the path "images/rivers.jpg"
    riversRef.putData(data, metadata: nil) { (metadata, error) in
        if let error = error {
            result = error.localizedDescription
            return
        } else {
            riversRef.downloadURL { (url, error) in
                if let error = error {
                    result = error.localizedDescription
                    return
                } else {
                    guard let downloadURL = url else {
                        result = "Error getting image URL"
                        return
                    }
                    result = downloadURL.absoluteString
                }
            }
        }
    }
    return result
}


class SessionProperties: ObservableObject {
    
    
    //add custom setters getters
    //@Published var avatar: ImageAttributes = placeholderImage
    
    @FirebasePublishedImage var avatar: ImageAttributes
    @FirebasePublished (key: .userName) var userName: String
    @FirebasePublished (key: .uid) var uid: String
    @FirebasePublished (key: .email) var email: String
    @Published var userSurname: String = "Alex2"
    @Published var nick: String? = nil
    @Published var bio: String = ""
    
    @AppStorage("test") var test = "test"
    
    
    @AppStorage("myimage") var imagestore: Data = Data()
    
    
    
    //    var image = UIImage(systemName: "house")
    //
    //    // Encode and store image
    //    func save() {
    //    if let data = image!.pngData() {
    //        imagestore = data
    //    }
    //    }
    //
    //    // Retrieve and decode image
    //      func get() {
    //    if let decodedImage: UIImage = UIImage(data: imagestore) {
    //         image = decodedImage
    //    }
    //
    //        save()
    //    }
    
    
    
    //@AppStorage("purchased") public var test = "test"
    
    
    //@appStorage("avatarPath") var avatarPath: String = ""
    //    @AppStorage("stuff") var notes: Int = 1
    //    @AppStorage("username") var username: String = "Anonymous"
}



extension Image {
    
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}

