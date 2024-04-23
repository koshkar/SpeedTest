//
//  MainView.swift
//  SpeedTestIos
//
//  Created by Кирилл Кошкарёв on 23.04.2024.
//

import SwiftUI

struct MainView: View {
    @State private var isSettingsSheet: Bool = false
    @State private var isSpeedTestPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            ZStack {
                HStack {
                    NavigationLink(destination: SpeedTestView()) {
                        Image(systemName: "network")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white)
                    }
                    .padding(.leading, 25)

                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white)
                    }
                    .padding(.trailing, 25)

                }

                
            }
            .navigationTitle("Main")
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            ).opacity(0.8)
            )
            .shadow(radius: 10, y: -5)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .offset(y: 10)
            .padding(.horizontal, 10)
            
            
        }
        
        
    }
    
}

enum Sheets {
    case none
    case settings
    case speedTest
}

#Preview {
    MainView()
}
