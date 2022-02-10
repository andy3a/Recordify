//
//  SessionProperties.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 8.02.22.
//

import Foundation
import SwiftUI
import Combine

let placeholderImage = ImageAttributes(withSFSymbol: "person.crop.circle.fill")
let placeholderImageTest = ImageAttributes(withSFSymbol: "house")


//@propertyWrapper
//struct UserSaved<Value> {
//    let
//}

final class SessionProperties: ObservableObject {
    
    
    //add custom setters getters
    //@Published var avatar: ImageAttributes = placeholderImage
    var objectWillChange = PassthroughSubject<Void, Never>()
    @Published var avatar: ImageAttributes = placeholderImage {
    willSet {
                objectWillChange.send()
            }
    }
    @AppStorage("test") var test = "test"
    
    
    @AppStorage("myimage") var imagestore: Data = Data()
    
    
  
    var image = UIImage(systemName: "house")
     
    // Encode and store image
    func save() {
    if let data = image!.pngData() {
        imagestore = data
    }
    }
     
    // Retrieve and decode image
      func get() {
    if let decodedImage: UIImage = UIImage(data: imagestore) {
         image = decodedImage
    }
        
        save()
    }
    
   
    
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

