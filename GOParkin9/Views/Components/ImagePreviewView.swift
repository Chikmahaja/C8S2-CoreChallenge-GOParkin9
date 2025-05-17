//
//  ImagePreviewView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct ImagePreviewView: View {
    let imageName: [UIImage]
    @Binding var selectedIndex: Int
    @Binding var isPresented: Bool
    
    var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                TabView(selection: $selectedIndex) {
                    ForEach(imageName.indices, id: \.self) { index in
                        Image(uiImage: imageName[index])
                            .resizable()
                            .scaledToFit()
                            .tag(index)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                            .onTapGesture {
                                isPresented = false
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
