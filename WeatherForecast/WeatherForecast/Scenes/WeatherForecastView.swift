//
//  WeatherForecastView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import SwiftUI
import Hydra

struct WeatherForecastView: View {

    @ObservedObject private var weatherViewModel = WeatherViewModel()

    @State private var enterCityAlertVisible = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {

                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 20)
                }

                Spacer()

                Button(action: {
                    enterCityAlertVisible.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                }
                .alert("Enter city", isPresented: $enterCityAlertVisible) {
                    TextField("", text: $weatherViewModel.address)

                    Button("OK", action: {
                        print("Fetching weather forecast for: \(weatherViewModel.address)")
                        weatherViewModel.fetchWeatherData()
                    })
                    Button("Cancel", role: .cancel) {}
                } message: {}
            }
            .padding(.top, 10)

            Spacer()

            if let weatherData = weatherViewModel.weatherData {
                CurrentWeatherView()
                    .padding(.bottom, 10)

                DailyForecastView()
                    .background(Color(UIColor.systemGroupedBackground))
            } else {
                Text("No weather forecast available")
            }
        }
        .alert("Error", isPresented: .constant(weatherViewModel.fetchingError != nil)) {

        } message: {
            Text("Fetching weather forecast for \(weatherViewModel.address) failed")
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
    }
}

struct CurrentWeatherView: View {

    var body: some View {
        VStack(spacing: 10) {
            Text("Poznań")
                .font(.title2)
            Text("20℃")
                .font(.system(size: 50))
            Image(systemName: "cloud")
                .font(.title2)
            Text("Partly cloudly")
                .font(.callout)
        }
    }
}

struct HourlyForecastView: View {

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
            }
        }
    }
}

struct HourlyForecastItemView: View {

    var body: some View {
        VStack(spacing: 4) {
            Text("00:00")
            Image(systemName: "cloud")
                .font(.title2)
            Text("20℃")
        }
        .padding(.vertical, 10)
        .frame(width: 90)
        .background(.gray)
        .cornerRadius(8)
    }
}

struct DailyForecastView: View {

    var body: some View {
        List {
            Section("Hourly forecast") {
                HourlyForecastView()
                    .padding(.vertical, 10)
            }

            Section("10 day forecast") {
                DailyForecastItemView()
                DailyForecastItemView()
                DailyForecastItemView()
            }
        }
    }
}

struct DailyForecastItemView: View {

    var body: some View {
        HStack {
            Text("Today")
                .font(.callout)
                .padding(.vertical, 10)
                .frame(maxWidth: 100, alignment: .leading)
                .background(.white)
            Spacer()
            Image(systemName: "cloud")
                .font(.title2)
            Spacer()
            Text("8℃ / 20℃")
                .frame(maxWidth: 120, alignment: .trailing)
                .background(.white)
        }
    }
}
