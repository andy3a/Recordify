//
//  Test.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 4.02.22.
//

import SwiftUI

struct Test: View {
    @State private var selection = 0

        var body: some View {

            TabView(selection: $selection) {
                NavigationView {
                    HomeView()
                        .navigationBarTitle(Text("First"))
                }
                .tabItem {
                    Label("Home", systemImage: "waveform.path.badge.plus")
                }
                .tag(0)

//                NavigationView {
//                    ProfileView(isLoggedIn: .constant(true))
//                        .navigationBarTitle(Text("Second"))
//                }
//                .tabItem {
//                    Label("Profile", systemImage: "waveform.path.badge.plus")
//                }
//                .tag(1)
            }.edgesIgnoringSafeArea(.top)
        }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
