//
//  BackgroundGradientView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct BackgroundGradientView: View {
    var mode: DayTimeMode
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: mode == .day ? [
                    Color.blue,
                    Color.cyan
                ] : [
                    Color.black,
                    Color.indigo
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundGradientView(mode: .night)
}


