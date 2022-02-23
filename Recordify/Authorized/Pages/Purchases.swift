//
//  Purchases.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 9.02.22.
//

import SwiftUI
import Firebase

struct Purchases: View {
    
    @EnvironmentObject var session: SessionProperties
    
 
    
    @State var cropped: UIImage?
    
    @State var cropManually: UIImage?
    
    var body: some View {
        
        VStack{
            
            Image(uiImage: cropManually ?? UIImage(named: "test")!)
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            Text("Cropped")
            Image(uiImage: cropped ?? UIImage(named: "test")!)
                .resizable()
                .frame(width: 100, height: 100)
            //.clipShape(Circle())
            
            session.avatar.image
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            Button("Load to server") {
                uploadToFirebase(image: cropped!) { result in
                    print ("\n \n \(String(describing: result))")
                }
                
            }
            
            Button("Load to Local") {
                uploadToFirebase(image: cropped!) { result in
                    print ("\n \n \(String(describing: result))")
                    saveURLToUserData(urlString: result)
                }
                
            }
            
        } .onAppear {
            
            cropped = session.avatar.croppedImage
            let image = session.avatar.originalImage
            let cropped = croppedImage(from: image!, croppedTo: CGRect(x: 1402.275679285637, y: 967.9537823119955, width: 1121.9359472990366, height: 1121.9359472990366))
            cropManually = cropped
        }
        
    }
    
    func croppedImage(from image: UIImage, croppedTo rect: CGRect) -> UIImage {

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: image.size.width, height: image.size.height)

        context?.clip(to: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))

        image.draw(in: drawRect)

        let subImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return subImage!
    }
    
    func saveURLToUserData(urlString: String) {
        let db = UsersDB.db
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        guard let checkedURL: URL = URL(string: urlString) else {return}
        db.collection("users").document(currentUID).setData(
            [
                "avatarURL": checkedURL.absoluteString
            ], merge: true)
        
    }
    
    func uploadToFirebase(image: UIImage, completion: @escaping (String) ->())  {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {
            completion("Error getting user UID")
            return
        }
        
        let data = image.jpegData(compressionQuality: 1.0) ?? Data()
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        //let uuid = UUID().uuidString
        let riversRef = storageRef.child("profileImages/\(currentUID)/avatar.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        riversRef.putData(data, metadata: nil) { (metadata, error) in
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
        
    }
}
