//
//  WeatherViewModel.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var mode: DayTimeMode = .day
    
    func toggleMode() {
        mode = mode == .day ? .night : .day
    }
}
