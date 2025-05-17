//
//  DetailRecordActive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import SwiftData

struct DetailRecordActive: View {
    @Binding var isPreviewOpen: Bool
    @Binding var isCompassOpen: Bool
    @Binding var selectedImageIndex: Int
    @State var dateTime: Date
    @State var parkingRecord: ParkingRecord
    @Environment(\.modelContext) var context
    
    @Binding var isComplete: Bool
    
    var body: some View {
        
        if parkingRecord.images.isEmpty {
            Text("There's no image")
                .foregroundColor(.red)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        } else {
            
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<parkingRecord.images.count, id: \.self) { index in
                    Image(uiImage: parkingRecord.images[index].getImage())
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 250)
                        .clipped()
                        .cornerRadius(10)
                        .tag(index)
                        .onTapGesture {
                            isPreviewOpen = true
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 250)
        }
        Spacer()
            .frame(height: 20)
        
        Grid {
            GridRow {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.6)
                        
                        Text("Date")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .opacity(0.6)
                        
                    }
                    
                    Text(parkingRecord.createdAt, format: .dateTime.day().month().year())
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "map")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.6)
                        
                        Text("Location")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .opacity(0.6)
                        
                    }
                    
                    Text("GOP 9, \(parkingRecord.floor)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        
        Spacer()
            .frame(height: 20)
        
        Grid {
            GridRow {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "arrow.down.backward.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.6)
                        
                        Text("Clock in")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .opacity(0.6)
                        
                    }
                    
                    Text(parkingRecord.createdAt, format: .dateTime.hour().minute())
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "arrow.up.forward.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.6)
                        
                        Text("Clock out")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .opacity(0.6)
                        
                    }
                    
                    Text("-")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 20)
            
            HStack(spacing: 16) {
                Button {
                    print("Navigate")
                    isCompassOpen.toggle()
                } label: {
                    HStack {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .fontWeight(.bold)
                            .scaledToFit()
                            .frame(height: 15)
                        
                        Text("Navigate")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .background(Color.secondary3)
                .foregroundStyle(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
