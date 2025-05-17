//
//  ContentView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/03/25.
//

import SwiftUI

struct ContentView: View {
    //@StateObject var navigationManager = NavigationManager()

    var body: some View {
        VStack {
            TabView {
                HomeView()
                   .tabItem {
                       Label("Menu", systemImage: "house")
                   }

                HistoryView()
                   .tabItem {
                       Label("History", systemImage: "clock")
                   }
            }
            .tint(.secondary1)
        }
        .ignoresSafeArea(.keyboard)
        .environment(\.sizeCategory, .large)
    }
}

#Preview {
    ContentView()
}
