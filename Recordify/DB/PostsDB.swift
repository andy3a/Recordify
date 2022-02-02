//
//  PostsDB.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import Foundation
import Firebase

class PostsDB {
    static let postsDB = PostsDB()
    static let db = Firestore.firestore()
    
    
    static let posts: [Post] = [
        Post(id: 0, recordName: "Post of the other user", imageName: nil),
        Post(id: 1, recordName: "Post 2", imageName: nil)
    ]
    
    private init() {
        
    }
}


