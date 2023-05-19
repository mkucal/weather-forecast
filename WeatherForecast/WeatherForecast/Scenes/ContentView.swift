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
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            WeatherForecastApiWorker().fetchDailyWeatherForecast(for: CLLocationCoordinate2D(latitude: 52.41, longitude: 16.93))
                .then { weatherData in
                    print("SUCCESS: \(weatherData)")
                }
                .catch { error in
                    print("ERROR: \(error)")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
