//
//  NavigationList.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct NavigationButton: Identifiable {
    let id: Int
    let name: String
    let image: Image
}

struct NavigationButtonList: View {

    let navigations: [NavigationButton]
    @Binding var selectedNavigation: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            ForEach(navigations) { navigation in
                Button {
                    selectedNavigation = navigation.id
                } label: {
                    VStack {
                        navigation.image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 60)
                            .cornerRadius(10)
                            .clipped()

                        Text(navigation.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 80)
                            .padding(.top, 5)
                            .foregroundColor(Color.primary)

                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.leading, 8)
        .padding(.vertical)
    }
}

struct NavigationList: View {

    @State var isCompassOpen: Bool = false
    @State var showCompassView: Bool = false
    @State var hasTakenRecord: Bool = false
    @State var selectedNavigation: Int = 0
    @State private var isModalPresented = false

    let navigations: [NavigationButton] = [
        NavigationButton(id:1, name: "Entry Gate Basement 1", image: Image("nav-EntryGateB1")),
        NavigationButton(id:2, name: "Exit Gate Basement 1", image: Image("nav-ExitGateB1")),
        NavigationButton(id:3, name: "Charging Station", image: Image("nav-ChargingStation")),
        NavigationButton(id:4, name: "Entry Gate Basement 2", image: Image("nav-EntryGateB2")),
        NavigationButton(id:5, name: "Exit Gate Basement 2", image: Image("nav-ExitGateB2")),
    ]
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        VStack(alignment: .leading) {

            // Header
            VStack(alignment: .leading) {
                Text("Navigate Around")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("Navigate to certain location around parking area")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }

            // Section with background
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    NavigationButtonList(
                        navigations: navigations,
                        selectedNavigation: $selectedNavigation
                    )
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                
                Spacer()
                    .frame(height: 12)

                Rectangle()
                    .foregroundColor(.secondary)
                    .frame(height: 0.5)
                    .padding(.horizontal, 10)

                Button {
                    isModalPresented = true
                } label: {
                    HStack {
                        Text("\(navigations.count) locations")
                            .font(.footnote)
                            .foregroundStyle(Color.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .frame(width: 60, height: 45, alignment: .trailing)
                    }
                    //.background(.yellow)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 7)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                    .padding(.vertical, 5)
            )

        }
        .onChange(of: selectedNavigation) {
            isCompassOpen.toggle()
            showCompassView = true
        }
        .fullScreenCover(isPresented: $isCompassOpen) {
            CompassView(
                isCompassOpen: $isCompassOpen,
                isComplete: $isCompassOpen,
                selectedLocation: selectedNavigation,
                longitude: 0,
                latitude: 0
            )
        }
        .sheet(isPresented: $isModalPresented) {
            NavigationListModalView(
                selectedLocation: selectedNavigation,
                isCompassOpen: $isCompassOpen,
                isComplete: $isCompassOpen,
                hasTakenRecord: $hasTakenRecord,
                isPresented: $isModalPresented // ← baru
            )
            .environmentObject(NavigationManager())
            .presentationDetents([.height(600)])
            .interactiveDismissDisabled(false)
        }
    }
}


#Preview {
    ContentView()
}
