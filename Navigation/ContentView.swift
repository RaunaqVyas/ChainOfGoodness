//
//  ContentView.swift
//  Chain Of Goodness
//
//  Created by Raunaq Vyas on 2023-03-11.
//

import SwiftUI
import Amplify

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @EnvironmentObject var model: Model
    
    let user: AuthUser
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            switch selectedTab {
            case .home:
                HomeView()
            case .explore:
                AccountView()
            case .notifications:
                AccountView()
            case .profile:
                ProfileView()
            }
            
            TabBar()
                .offset(y: model.showDetail ? 200 : 0)
            
//            if showModal {
//                ModalView()
//                    .zIndex(1)
//            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear.frame(height: 44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    static var previews: some View {
        Group {
            ContentView(user: DummyUser())
            ContentView(user: DummyUser())
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 13 mini")
        }
        .environmentObject(Model())
    }
}
