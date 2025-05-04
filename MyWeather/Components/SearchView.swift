//
//  SearchView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var cityName = ""
    @Environment(\.dismiss) private var dismiss
    var onSearch: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter city name", text: $cityName)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
                
                Button {
                    if !cityName.isEmpty {
                        onSearch(cityName)
                        dismiss()
                    }
                } label: {
                    Text("Search")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(cityName.isEmpty)
                .opacity(cityName.isEmpty ? 0.6 : 1)
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            // Focus the text field when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // This would be the place to focus, but UIKit integration is needed
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.cyan]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        SearchView { _ in }
    }
}
