//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import SwiftUI
import CoreLocation
import Hydra

struct ContentView: View {

    @ObservedObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("\(weatherViewModel.weatherData.debugDescription)")
        }
        .padding()
        .onAppear {
            weatherViewModel.fetchWeatherData(for: "Poznań")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
