//
//  UserApp.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import SwiftUI
import FirebaseAuth


struct CreatorApp: View {
    
    @State var isActive = false
    @Binding var isLoggedIn: Bool?
    @StateObject var session = SessionProperties()
    
    
    
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
                      
            NavigationView{
            HomeView()
                    .navigationTitle("Home")
            }
                .tabItem {
                    Label("Home", systemImage: "house")
                    
                }
            
                .tag(0)
            NavigationView{
            CreateView()
                    .navigationTitle("Create")
            }
                .tabItem {
                    Label("Add", systemImage: "waveform.path.badge.plus")
                }
                .tag(1)
            
            NavigationView{
                ProfileView(isLoggedIn: $isLoggedIn)
                    .navigationTitle("Profile")
                   
            }
            
                .tabItem {
                    Label("Profile", systemImage: "person")
                    
                }
                .tag(2)
        }
        .accentColor(Color(UIColor(named: "accent")!))
        .environmentObject(session)
    }
}

struct CreatorApp_Previews: PreviewProvider {
    static var previews: some View {
        CreatorApp(isLoggedIn: .constant(true))
            .preferredColorScheme(.dark)
    }
}
