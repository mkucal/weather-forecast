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

    private var showActivityIndicator: Bool {
        weatherViewModel.fetchingState == .running
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        if let weatherForecastViewModel = weatherViewModel.weatherForecastViewModel {
                            weatherViewModel.address = weatherForecastViewModel.address
                            print("Fetching weather forecast for: \(weatherViewModel.address)")
                            weatherViewModel.fetchWeatherData()
                        }
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
                .tint(Color(UIColor.darkGray))

                Spacer()

                if let viewModel = weatherViewModel.weatherForecastViewModel {
                    CurrentWeatherView(address: viewModel.address, weatherViewModel: viewModel.currentWeather)
                        .padding(.bottom, 10)

                    ForecastView(forecastViewModel: viewModel)
                } else {
                    Text("No weather forecast available")
                }
            }
            .alert("Error", isPresented: .constant(weatherViewModel.fetchingError != nil)) {
                Button("OK", action: {
                    weatherViewModel.fetchingError = nil
                })
            } message: {
                Text("Fetching weather forecast for \(weatherViewModel.address) failed")
            }
            .disabled(showActivityIndicator)
            .blur(radius: showActivityIndicator ? 2 : 0)

            if showActivityIndicator {
                ActivityIndicatorView()
            }
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
    }
}
