//
//  ContentView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showSearchView = false
    
    var body: some View {
        ZStack {
            // Background gradient
            BackgroundGradientView(mode: viewModel.mode)
            
            // Content based on loading state
            if viewModel.isLoading {
                LoadingView()
            } else if let error = viewModel.error, viewModel.showError {
                ErrorView(error: error) {
                    // Retry action
                    if let weather = viewModel.currentWeather {
                        viewModel.fetchWeather(for: weather.cityName)
                    } else {
                        viewModel.fetchWeatherForCurrentLocation()
                    }
                }
            } else {
                // Weather content
                VStack(spacing: 20) {
                    // City and main weather info
                    if let weather = viewModel.currentWeather {
                        MainWeatherStatusView(
                            mode: viewModel.mode,
                            city: viewModel.cityName,
                            imageName: weather.weatherIconName,
                            temperature: Int(round(weather.temperature)),
                            degree: "\(Int(round(weather.temperature)))"
                        )
                    } else {
                        MainWeatherStatusView(
                            mode: viewModel.mode,
                            city: viewModel.cityName,
                            imageName: viewModel.mode == .night ? "moon.stars.fill" : "sun.max.fill",
                            temperature: 0,
                            degree: "0"
                        )
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    // Daily forecast
                        HStack(spacing: 20) {
                            if viewModel.forecasts.isEmpty {
                                // Show placeholder if no forecast data
                                ForEach(0..<5) { index in
                                    WeatherDayView(
                                        mode: viewModel.mode,
                                        weatherTitle: "...",
                                        weatherIamge: Image(systemName: "cloud.fill"),
                                        temperature: 0
                                    )
                                }
                            } else {
                                // Show actual forecast data
                                ForEach(viewModel.forecasts.prefix(5), id: \.day) { forecast in
                                    WeatherDayView(
                                        mode: viewModel.mode,
                                        weatherTitle: forecast.day,
                                        weatherIamge: Image(systemName: forecast.iconName),
                                        temperature: forecast.averageTemp
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    
                    
                    Spacer()
                        .frame(height: 100)
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        // Search button
                        Button {
                            showSearchView = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Circle().fill(Color.blue.opacity(0.6)))
                        }
                        
                        // Location button
                        Button {
                            viewModel.fetchWeatherForCurrentLocation()
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Circle().fill(Color.blue.opacity(0.6)))
                        }
                        
                        Button {
                            viewModel.toggleMode()
                        } label: {
                            WeatherButton(
                                mode: viewModel.mode,
                                title: viewModel.mode == .night ? "Switch to Light Mode" : "Switch to Dark Mode",
                                textColor: viewModel.mode == .night ? .white : .blue,
                                buttonColor: viewModel.mode == .night ? .blue : .white
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSearchView) {
            ZStack {
                SearchView { city in
                    viewModel.fetchWeather(for: city)
                }
            }
            .presentationDetents([.height(300)])
        }
        .alert(viewModel.error?.errorDescription ?? "Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            // Fetch weather when the view appears
            viewModel.fetchWeatherForCurrentLocation()
        }
    }
}

#Preview {
    HomeView()
}
