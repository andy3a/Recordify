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
       
        ScrollView {
           
            RowWithPost(post: posts[0])
            RowWithPost(post: posts[1])
            RowWithPost(post: posts[0])
            RowWithPost(post: posts[1])
            RowWithPost(post: posts[0])
            RowWithPost(post: posts[1])
            RowWithPost(post: posts[0])
            RowWithPost(post: posts[1])

                
        }
        .navigationBarBackButtonHidden(true)
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
