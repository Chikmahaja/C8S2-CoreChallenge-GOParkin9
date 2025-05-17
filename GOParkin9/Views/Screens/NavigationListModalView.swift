//
//  ModalNavigationListView.swift
//  GOParkin9
//
//  Created by Chikmah on 17/05/25.
//

import SwiftUI
import CoreLocation

enum SortMode: String {
    case `default` = "Default"
    case nearest = "Nearest"
}

struct Options: Identifiable {
    let id: Int
    let name: String
    let image: Image
    let coordinate: CLLocationCoordinate2D
}

struct NavigationListModalView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    var selectedLocation: Int
    @Binding var isCompassOpen: Bool
    @Binding var isComplete: Bool
    @Binding var isPresented: Bool
    
    @State private var sortMode: SortMode = .default
    
    var navigationOptions: [Options] = [
        Options(id: 1, name: "Entry Gate Basement 1", image: Image("nav-EntryGateB1"), coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Options(id: 2, name: "Exit Gate Basement 1", image: Image("nav-ExitGateB1"), coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Options(id: 3, name: "Charging Station", image: Image("nav-ChargingStation"), coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612)),
        Options(id: 4, name: "Entry Gate Basement 2", image: Image("nav-EntryGateB2"), coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Options(id: 5, name: "Exit Gate Basement 2", image: Image("nav-ExitGateB2"), coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761))
    ]
    
    var sortedOptions: [Options] {
        switch sortMode {
        case .default:
            return navigationOptions.sorted { $0.id < $1.id }
        case .nearest:
            return navigationOptions.sorted {
                navigationManager.distance(to: $0.coordinate) < navigationManager.distance(to: $1.coordinate)
            }
        }
    }
    
    func distanceText(for destination: CLLocationCoordinate2D) -> String {
        let distance = navigationManager.distance(to: destination)
        if distance == 0 {
            return "Loading..."
        } else if distance > 999 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return "\(Int(distance)) m"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Menu {
                        Button { sortMode = .default } label: { Text("Default") }
                        Button { sortMode = .nearest } label: { Text("Nearest") }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.callout)
                                .padding(.trailing, 4)
                            Text(sortMode.rawValue)
                                .font(.callout)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                    }
                    
                    Spacer()
                    
                    Button("Close") {
                        isPresented = false
                    }
                    .foregroundColor(.red)
                    .font(.callout)
                    
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .padding(.bottom, -5)
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                
                List(sortedOptions) { nav in
                    NavigationLink {
                        CompassView(
                            isCompassOpen: $isCompassOpen,
                            isComplete: $isComplete,
                            selectedLocation: nav.id,
                            longitude: nav.coordinate.longitude,
                            latitude: nav.coordinate.latitude
                        )
                    } label: {
                        HStack(alignment: .top, spacing: 15) {
                            nav.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 60)
                                .cornerRadius(8)
                                .clipped()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(nav.name)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2)
                                Text(distanceText(for: nav.coordinate))
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, -5)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, -18)
            .padding(.horizontal, -5)
        }
        .cornerRadius(15)
    }
}

struct NavigationListModalView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var isCompassOpen = false
        @State var isComplete = false
        @State var isPresented = true
        
        var body: some View {
            NavigationListModalView(
                selectedLocation: 1,
                isCompassOpen: $isCompassOpen,
                isComplete: $isComplete,
                isPresented: $isPresented
            )
            .environmentObject(NavigationManager())
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
