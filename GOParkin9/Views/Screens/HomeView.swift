//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showAlert = true
    @State private var hasTakenRecord = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                        if hasTakenRecord {
                            DetailRecord()
                            NavigationList()
                        } else {
                            NavigationList()
                            DetailRecord()
                        }
                    }
                .navigationTitle("GOParkin9")
                .padding()
            }
        }
            
    }
}

#Preview {
    ContentView()
}
