//
//  CompassIndicatorView.swift
//  GOParkin9
//
//  Created by Chikmah on 16/05/25.
//

import SwiftUI

struct CompassIndicatorView: View {

    @ObservedObject var navigationManager : NavigationManager
    @ObservedObject var compassVM : CompassViewModel
    
    var body: some View {
        ZStack {
            if compassVM.formattedDistance.1 <= 5 {
                Circle()
                    .fill(Color.secondary3)
                    .frame(width: 150, height: 150)
                    .scaleEffect(compassVM.isPulsing ? 1.2 : 0.8)
                    .opacity(compassVM.isPulsing ? 0.5 : 1.0)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                            compassVM.isPulsing.toggle()
                        }
                        
                        if compassVM.isSpeechEnabled {
                            if let selected = compassVM.options.first(where: { $0.id == compassVM.selectedLocation }) {
                                compassVM.speechUtteranceManager.speak(text: "You have arrived at \(selected.name)")
                            }
                        }
                    }
            } else {
                Image(systemName: "arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
                    .foregroundColor(Color.secondary3)
                    .rotationEffect(.degrees(compassVM.displayedAngle))
                    .onChange(of: navigationManager.angle(to: compassVM.targetDestination)) { newRawAngle in
                        compassVM.updateDisplayedAngle(to: newRawAngle)
                        
                    }
                    .onChange(of: compassVM.clockDirection) {
                        compassVM.speechUtteranceManager.stopSpeaking()
                        if compassVM.isSpeechEnabled {
                            compassVM.speechUtteranceManager.speak(text: "Turn to the \(compassVM.clockDirection)")
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: compassVM.formattedDistance.1)
    }
}

//#Preview {
//    CompassIndicatorView()
//}
