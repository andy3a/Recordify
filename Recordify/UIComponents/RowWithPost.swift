//
//  RowWithPost.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import SwiftUI

struct RowWithPost: View {
    var post: Post
    
   
    
    var body: some View {
        HStack {
            Text(post.recordName)
            Spacer()
        }
    }
}

struct RowWithPost_Previews: PreviewProvider {
    static var previews: some View {
        let posts: [Post] = [
            Post(id: 0, recordName: "Post of the other user", imageName: nil),
            Post(id: 1, recordName: "Post 2", imageName: nil)
        ]
        
        
        RowWithPost(post: posts[1])
    }
}
