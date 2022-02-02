//
//  HomeView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import SwiftUI

struct HomeView: View {
    
    let posts = PostsDB.posts
    
    var body: some View {
        List {
            RowWithPost(post: posts[0])
            RowWithPost(post: posts[1])
                }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
