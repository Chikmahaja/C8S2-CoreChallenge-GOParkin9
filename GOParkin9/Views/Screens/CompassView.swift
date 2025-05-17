//
//  CompassView2.swift
//  GOParkin9
//
//  Created by Chikmah on 16/05/25.
//

import SwiftUI
import CoreLocation
import SwiftData

struct Location: Identifiable {
    let id: Int
    let name: String
    let label: String
    let coordinate: CLLocationCoordinate2D
}

class CompassViewModel: ObservableObject {
    @Published var navigationManager = NavigationManager()
    @Published var isSpeechEnabled = false
    
    @Published var isCompassOpen: Bool
    @Published var isComplete: Bool
    
    @Published var selectedLocation: Int
    @Published var longitude: Double
    
    @Published var latitude: Double
    
    @Published var previousAngle: Double = 0
    @Published var displayedAngle: Double = 0
    @Published var isPulsing = false
    
    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == false}) var parkingRecords: [ParkingRecord]
    
    var firstParkingRecord: ParkingRecord? {
        parkingRecords.first
    }
    
    @Published var options = [
        Location(id:1, name: "Entry Gate B1", label: "Entry Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Location(id:2, name: "Exit Gate B1", label: "Exit Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Location(id:3, name: "Charging Station", label: "Charging Station", coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612)),
        Location(id:4, name: "Entry Gate B2", label: "Entry Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Location(id:5, name: "Exit Gate B2", label: "Exit Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761))
    ]
    
    var speechUtteranceManager = SpeechUtteranceManager()
    
    var targetDestination: CLLocationCoordinate2D {
        
        options.first(where: { $0.id == selectedLocation })?.coordinate ??
        CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
    }
    
    var currentAngle: Double {
        navigationManager.angle(to: targetDestination)
    }
    
    func updateDisplayedAngle(to newAngle: Double) {
        let normalizedNew = newAngle.truncatingRemainder(dividingBy: 360)
        let normalizedPrev = previousAngle.truncatingRemainder(dividingBy: 360)
        
        var delta = normalizedNew - normalizedPrev
        if delta > 180 {
            delta -= 360
        } else if delta < -180 {
            delta += 360
        }
        
        let smoothedAngle = displayedAngle + delta
        
        withAnimation(.easeInOut(duration: 0.4)) {
            displayedAngle = smoothedAngle
        }
        
        previousAngle = normalizedNew
    }
    
    var clockDirection: String {
        switch currentAngle {
        case 0..<15, 345...360:
            return "12 o'clock"
        case 15..<45:
            return "1 o'clock"
        case 45..<75:
            return "2 o'clock"
        case 75..<105:
            return "3 o'clock"
        case 105..<135:
            return "4 o'clock"
        case 135..<165:
            return "5 o'clock"
        case 165..<195:
            return "6 o'clock"
        case 195..<225:
            return "7 o'clock"
        case 225..<255:
            return "8 o'clock"
        case 255..<285:
            return "9 o'clock"
        case 285..<315:
            return "10 o'clock"
        case 315..<345:
            return "11 o'clock"
        default:
            return "Unknown direction"
        }
    }
    
    
    func speak(_ text: String) {
        if isSpeechEnabled {
            speechUtteranceManager.stopSpeaking()
            speechUtteranceManager.speak(text: text)
        }
    }

    func appendLocationActiveParking() {
        if let record = firstParkingRecord {
            options.append(Location(id:6 , name: "Parking Location", label: "Parking Location", coordinate: CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)))
        }
        
        if selectedLocation==7 {
            options.append(Location(id:7, name: "Parking Location History", label: "Parking Location History", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        }
    }
    
    
    var formattedDistance: (String, Int) {
        let distance = navigationManager.distance(to: targetDestination)
//        print("Distance: \(distance)")
        if distance > 999 {
            return (String(format: "%.2f km", distance / 1000), Int(distance))
        } else {
            return ("\(Int(distance)) m", Int(distance))
        }
    }

    func complete(context: ModelContext) {
        firstParkingRecord?.isHistory = true
        firstParkingRecord?.completedAt = Date.now
        try? context.save()
        print("Complete")
    }
    
    init(isSpeechEnabled: Bool = false, isCompassOpen: Bool, isComplete: Bool, selectedLocation: Int, longitude: Double, latitude: Double, previousAngle: Double, displayedAngle: Double, isPulsing: Bool = false, parkingRecords: [ParkingRecord], options: [Location] = [
        Location(id:1, name: "Entry Gate B1", label: "Entry Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Location(id:2, name: "Exit Gate B1", label: "Exit Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Location(id:3, name: "Charging Station", label: "Charging Station", coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612)),
        Location(id:4, name: "Entry Gate B2", label: "Entry Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Location(id:5, name: "Exit Gate B2", label: "Exit Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761))
    ], speechUtteranceManager: SpeechUtteranceManager = SpeechUtteranceManager()) {
        self.isSpeechEnabled = isSpeechEnabled
        self.isCompassOpen = isCompassOpen
        self.isComplete = isComplete
        self.selectedLocation = selectedLocation
        self.longitude = longitude
        self.latitude = latitude
        self.previousAngle = previousAngle
        self.displayedAngle = displayedAngle
        self.isPulsing = isPulsing
        self.options = options
        self.speechUtteranceManager = speechUtteranceManager
    }
    
}

struct CompassView: View {
    @Binding var isCompassOpen: Bool
    @Binding var isComplete: Bool
    
    var selectedLocation: Int
    var longitude: Double
    var latitude: Double

    @StateObject var navigationManager = NavigationManager()
    
    @StateObject var compassVM: CompassViewModel
    
    init(isCompassOpen: Binding<Bool>, isComplete: Binding<Bool>, selectedLocation: Int, longitude: Double, latitude: Double, firstParkingRecord: ParkingRecord? = nil) {
        self._isCompassOpen = isCompassOpen
        self._isComplete = isComplete
        self.selectedLocation = selectedLocation
        self.longitude = longitude
        self.latitude = latitude
        self.firstParkingRecord = firstParkingRecord
        self._compassVM = StateObject(wrappedValue: CompassViewModel(
            isCompassOpen: false,
            isComplete: false,
            selectedLocation: selectedLocation,
            longitude: longitude,
            latitude: latitude,
            previousAngle: 0.0,
            displayedAngle: 0.0,
            parkingRecords: []
        ))
    }
    
    @Environment(\.modelContext) var context
    
    var firstParkingRecord: ParkingRecord?
    
    func complete() {
        if let record = firstParkingRecord {
            record.isHistory = true
            record.createdAt = Date()
            try? context.save()
            print("Complete")
            
            isCompassOpen.toggle()
        }
    }
 
    var body: some View {
            VStack {
                HStack {
    
                    Button {
                        isCompassOpen = false
                    } label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.secondary1)
                            .padding(25)
                    }
    
                    Spacer()
                    
                    Text("Navigate to")
                        .font(.title3)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(25)
                    
                    Spacer()
    
                    Button {
                        if compassVM.isSpeechEnabled {
                            compassVM.speechUtteranceManager.stopSpeaking()
                        } else {
                            if compassVM.formattedDistance.1 <= 5 {
                                compassVM.speechUtteranceManager.speak(text: "You have arrived at \(compassVM.selectedLocation)")
                            } else {
                                compassVM.speechUtteranceManager.speak(text: "Turn to the \(compassVM.clockDirection)")
                            }
                        }
                        compassVM.isSpeechEnabled.toggle()
                    } label: {
                        Image(systemName: compassVM.isSpeechEnabled ? "speaker.wave.2" : "speaker.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.secondary1)
                            .padding(20)
                            .animation(nil, value: compassVM.isSpeechEnabled)
                    }
    
                }
                .padding(10)
                
                if firstParkingRecord != nil {
                    Text("Parking Location")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 10)
                } else {
                    
                    Text(compassVM.options.first(where: {$0.id == selectedLocation})?.name ?? "kosong")
                            .font(.title)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 10)
                    
                }
                
                Spacer()
                
                CompassIndicatorView(navigationManager: navigationManager, compassVM: compassVM)
                
                Spacer()
                    .frame(height: 100)
                
                if compassVM.formattedDistance.1 <= 5 {
                    Text("Check nearby vehicle in the area")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Text("You have arrived at location")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .opacity(0.8)
                    
                } else {
                    Text("Turn to the \(compassVM.clockDirection)")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Text("\(compassVM.formattedDistance.0) to location")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                        .opacity(0.8)
                }
                
                
                Spacer()
                    .frame(height: 40)

                Button {
                    if firstParkingRecord != nil {
                        complete()
                    } else  {
                        isCompassOpen.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                            .resizable()
                            .fontWeight(.bold)
                            .scaledToFit()
                            .frame(height: 15)
                        
                        Text("Finish Navigation")
                            .font(.body)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .background(Color.secondary3)
                .foregroundStyle(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .padding()
                
                Spacer()
                    .frame(height: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .onAppear {
                compassVM.appendLocationActiveParking()
            }
        }
}

