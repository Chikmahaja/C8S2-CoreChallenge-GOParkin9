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
                VStack(alignment: .leading, spacing: 30) {
                        if hasTakenRecord {
                            DetailRecord(hasTakenRecord: $hasTakenRecord)
                                .padding(.top, -20)
                                .padding(.bottom, 10)
                            NavigationList()
                        } else {
                            NavigationList()
                                .padding(.bottom, -20)
                            DetailRecord(hasTakenRecord: $hasTakenRecord)
                        }
                    }
                .navigationTitle("GOParkin9")
                .font(.title)
                .padding()
            }
        }
            
    }
}

#Preview {
    ContentView()
}
