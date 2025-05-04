//
//  ContentView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        ZStack {
            BackgroundGradientView(mode: viewModel.mode)
            VStack(spacing: 20) {
                MainWeatherStatusView(
                    mode: viewModel.mode,
                    city: "Port Harcourt",
                    imageName: viewModel.mode == .night ? "moon.stars.fill" : "sun.max.fill",
                    temperature: 24, degree: "24"
                )
                Spacer()
                    .frame(height: 50)
                    HStack(spacing: 10) {
                        
                        WeatherDayView(
                            mode: viewModel.mode,
                            weatherTitle: "tue",
                            weatherIamge: Image(systemName: "cloud.sun.fill"),
                            temperature: 25
                        )
                        WeatherDayView(
                            mode: viewModel.mode,
                            weatherTitle: "wed",
                            weatherIamge: Image(systemName: "cloud.sun.rain.fill"),
                            temperature: 18
                        )
                        WeatherDayView(
                            mode: viewModel.mode,
                            weatherTitle: "thu",
                            weatherIamge: Image(systemName: "cloud.snow.fill"),
                            temperature: 10
                        )
                        WeatherDayView(
                            mode: viewModel.mode,
                            weatherTitle: "fri",
                            weatherIamge: Image(systemName: "cloud.sun.fill"),
                            temperature: 26
                        )
                        WeatherDayView(
                            mode: viewModel.mode,
                            weatherTitle: "sat",
                            weatherIamge: Image(systemName: "sun.max.fill"),
                            temperature: 32
                        )
                    }
               
                
                Spacer()
                    .frame(height: 100)
                Button {
                    viewModel.toggleMode()
                } label: {
                    WeatherButton(
                        mode: viewModel.mode,
                        title: viewModel.mode == .night ? "Switch to Light Mode" : "Switch to Dark Mode",
                        textColor: viewModel.mode == .night ? .white : .black,
                        buttonColor: viewModel.mode == .night ? .blue : .white
                    )
                        
                }

            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
