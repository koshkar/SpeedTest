//
//  SpeedTestView.swift
//  SpeedTestIos
//
//  Created by Кирилл Кошкарёв on 23.04.2024.
//

import SwiftUI

struct SpeedTestView: View {
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color.purple)
                    }
                    Text("Start speed test")
                        .bold()
                        .foregroundStyle(Color(.purple))
                }
                .padding(.top, 200)
                                
                Spacer()
                
                HStack {
                    VStack {
                        Text("1")
                        Text("2")
                    }
                    .padding(.bottom, 150)
                    .padding(.leading, 20)
                    
                    Spacer()
                }
            }
            
            .navigationTitle("Speed Test")
        }
    }
}

#Preview {
    SpeedTestView()
}
