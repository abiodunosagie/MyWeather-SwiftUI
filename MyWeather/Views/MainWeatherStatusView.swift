//
//  MainWeatherStatusView.swift
//  MyWeather
//
//  Created by Abiodun Osagie on 04/05/2025.
//

import SwiftUI

struct MainWeatherStatusView: View {
    // MARK: - PROPERTIES
    var mode: DayTimeMode
    var city: String
    var imageName: String
    var temperature: Int
    var degree: String
    var body: some View {
        VStack {
            Text(city)
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .padding(.horizontal)
            
            Image(systemName: imageName)
                .font(.system(size: 150, weight: .light))
                .foregroundStyle(mode == .day ? Color.yellow : Color.white)
                .padding(.top,10)
            
            Text("\(temperature)°")
                .font(.system(size: 35, weight: .bold))
                .foregroundStyle(.white)
            
        }
    }
}

