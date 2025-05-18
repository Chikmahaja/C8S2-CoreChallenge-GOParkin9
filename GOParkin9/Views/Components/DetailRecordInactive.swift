//
//  DetailRecordInactive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
 
struct DetailRecordInactive: View {
    @Binding var hasTakenRecord: Bool
    
    @State private var showAlertSaveLocation: Bool = false
    @State private var showingSheet: Bool = false
    //@State private var hasTakenRecord = false
    
    let locationManager = NavigationManager()
    @State private var savedLocation: CLLocationCoordinate2D?
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
                .frame(height: 35)
            
            Image(systemName: "parkingsign.radiowaves.left.and.right.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.gray)
                .opacity(0.6)
            
            Spacer()
                .frame(height: 45)
            
            Button {
                showAlertSaveLocation.toggle()
                
            } label: {
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    Text("Mark This Spot")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
            
        }
        .sheet(isPresented: $showingSheet) {
            if let location = savedLocation {
                ModalView(onRecordSaved: {hasTakenRecord = true}, savedLocation: location)
            }
        }
        .alertComponent(
            isPresented: $showAlertSaveLocation,
            title: "Saving Location",
            message: "Are you sure you are in your parking spot?",
            cancelButtonText: "No",
            confirmAction: {
                savedLocation = locationManager.location?.coordinate
            },
            confirmButtonText: "Yes"
        )
        .onChange(of: savedLocation) { newValue in
            if newValue != nil {
                showingSheet = true
            }
        }
        .onAppear {
            hasTakenRecord = false
        }
        
    }
}

#Preview {
    ContentView()
}
