//
//  ErrorView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct ErrorView: View {
    var error: WeatherError
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow)
            
            Text("Oops! Something went wrong")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text(error.errorDescription ?? "Unknown error")
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                retryAction()
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .padding()
                    .frame(width: 200)
                    .background(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        ErrorView(error: .cityNotFound) { }
    }
}
