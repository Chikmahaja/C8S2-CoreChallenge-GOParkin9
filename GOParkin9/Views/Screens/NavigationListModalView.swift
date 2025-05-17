//
//  ModalNavigationListView.swift
//  GOParkin9
//
//  Created by Chikmah on 17/05/25.
//

import SwiftUI
import CoreLocation

struct Options: Identifiable {
    let id: Int
    let name: String
    let image: Image
    let coordinate: CLLocationCoordinate2D
}

struct NavigationListModalView: View {
    
    var navigationOptions: [Options] = [
        Options(id: 1, name: "Entry Gate Basement 1", image: Image("nav-EntryGateB1"), coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Options(id: 2, name: "Exit Gate Basement 1", image: Image("nav-ExitGateB1"), coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Options(id: 3, name: "Charging Station", image: Image("nav-ChargingStation"), coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612)),
        Options(id: 4, name: "Entry Gate Basement 2", image: Image("nav-EntryGateB2"), coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Options(id: 5, name: "Exit Gate Basement 2", image: Image("nav-ExitGateB2"), coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761))
    ]
    
    @State var navigationManager = NavigationManager()
    @State var selectedLocation: Int
    @State private var isReverse: Bool = false
    
    // Computed property untuk sorting
    var sortedOptions: [Options] {
        navigationOptions.sorted {
            let d1 = navigationManager.distance(to: $0.coordinate)
            let d2 = navigationManager.distance(to: $1.coordinate)
            return isReverse ? d1 > d2 : d1 < d2
        }
    }
    
    var targetDestination: CLLocationCoordinate2D {
        navigationOptions.first(where: { $0.id == selectedLocation
        })?.coordinate ??
        CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    // jarak user ke lokasi pilihan
    func distanceText(for destination: CLLocationCoordinate2D) -> String {
        let distance = navigationManager.distance(to: destination)
        if distance > 999 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return "\(Int(distance)) m"
        }
    }
    
    var body: some View {
        NavigationView {
            List(sortedOptions, id: \.id) { nav in
                HStack(spacing: 15) {
                    nav.image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 40)
                        .cornerRadius(8)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(nav.name)
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Text(distanceText(for: nav.coordinate))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Navigate to")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            isReverse.toggle()
                        } label: {
                            Text(isReverse ? "Default Order" : "Reverse Order")
                                .font(.subheadline)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("Default")
                                .font(.caption)
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}


#Preview{
    NavigationListModalView( selectedLocation: 1)
}
