//
//  DetailRecord.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import SwiftData

struct DetailRecord: View {
    
    @State private var selectedImageIndex = 0
    @State private var isPreviewOpen = false
    @State var isCompassOpen: Bool = false
    
    @State var isComplete: Bool = false
    @Binding var hasTakenRecord: Bool

    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == false}) var parkingRecords: [ParkingRecord]

    var firstParkingRecord: ParkingRecord? {
        parkingRecords.first
    }

    @Query var parkingRecordss: [ParkingRecord]
    @Environment(\.modelContext) var context
    
    func finishNavigation() {
        hasTakenRecord = false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                if let record = firstParkingRecord {
                    DetailRecordActive(
                        isPreviewOpen: $isPreviewOpen,
                        isCompassOpen: $isCompassOpen,
                        selectedImageIndex: $selectedImageIndex,
                        hasTakenRecord: $hasTakenRecord,
                        dateTime: record.createdAt,
                        parkingRecord: record,
                        isComplete: $isComplete
                    )
                } else {
                    DetailRecordInactive( hasTakenRecord: $hasTakenRecord)
                }

            } header: {
                VStack(alignment: .leading) {
                    Text("Currently Parked")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if let _ = firstParkingRecord {
                        Text("Details of your parking activity")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    } else {
                        Text("There’s no record of your parking activity. Save your parking location now!")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                    }
                }
                .padding(.vertical)
            }

            .fullScreenCover(isPresented: $isPreviewOpen) {
                if let image = firstParkingRecord?.images[selectedImageIndex].getImage() {
                    ImagePreviewView(imageName: [image], selectedIndex: $selectedImageIndex, isPresented: $isPreviewOpen)
                }
            }
            .fullScreenCover(isPresented: $isCompassOpen) {

                if let record = firstParkingRecord {
                    CompassView(
                        isCompassOpen: $isCompassOpen,
                        isComplete: $isCompassOpen,
                        selectedLocation: 6,
                        longitude: record.longitude,
                        latitude: record.latitude,
                        firstParkingRecord: firstParkingRecord
                    )
                }
            }
        }
        .onAppear {
            if firstParkingRecord != nil{
                hasTakenRecord = true
            }
            else {
                hasTakenRecord = false
            }
        }
    }
}

#Preview {
    ContentView()
}
