//
//  RecordifyApp.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct RecordifyApp: App {
    
    init() {
        FirebaseApp.configure()
        //uploadImage()
        findIfUserLoggedIn()
        
    }
    
    @State var isLoggedIn: Bool? = nil
    
    
    func findIfUserLoggedIn() {
        if Auth.auth().currentUser != nil && Auth.auth().currentUser?.isEmailVerified == true {
            UsersDB.getSavedUser { error in
                print("ERROR is \(error)")
                if let error = error {
                    return
                } else {
                isLoggedIn = true
                    return
                }
            }
        }
        guard let _ = isLoggedIn else {
            isLoggedIn = false
            return
        }
    }
    
    func setItTrue() {
        isLoggedIn = true
        print(isLoggedIn)
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                if isLoggedIn == nil
                { ProgressView()
                    
                } else {
                    
                    if isLoggedIn! && UsersDB.currentUser?.role == "user" {
                        AnyView(UserApp(isLoggedIn: $isLoggedIn))
                    }
                    if isLoggedIn! && UsersDB.currentUser?.role == "creator" {
                        AnyView(CreatorApp(isLoggedIn: $isLoggedIn))
                    }
                    if isLoggedIn == false {
                        LoginView(isLoggedIn: $isLoggedIn)
                    }
                }
            }
            .onAppear {
                findIfUserLoggedIn()
            }
        }
        
    }
    
    func uploadImage(iamge: UIImage? =  nil) -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let riverUUID = getUUID()
        let myImageFile = saveImage(image: UIImage(named: "test")!, UUIDString: riverUUID)
        var resultURL: URL? = nil
        
        print(myImageFile!)
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/\(riverUUID).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        _ = riversRef.putFile(from: myImageFile!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("ERROR is \(String(describing: error))")
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let _ = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                resultURL = downloadURL
                print("ERROR is \(String(describing: error?.localizedDescription))")
            }
        }
        return resultURL
    }
    
    func getUUID() -> String {
        return UUID().uuidString
    }
    
    func saveImage(image: UIImage, UUIDString: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let fileURL = documentsDirectory.appendingPathComponent(UUIDString)
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
            return fileURL
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
