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
        weatherViewModel.isFetchingRunning
    }

    private var weatherForecastViewModel: WeatherForecastViewModel? {
        weatherViewModel.weatherForecastViewModel
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    // Refresh button

                    Button(action: {
                        if let viewModel = weatherForecastViewModel {
                            weatherViewModel.address = viewModel.address
                            fetchWeatherData()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 20)
                    }

                    Spacer()

                    // Configure city button

                    Button(action: {
                        enterCityAlertVisible.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 20)
                    }
                    .alert(NSLocalizedString("Enter city", comment: ""), isPresented: $enterCityAlertVisible) {
                        TextField("", text: $weatherViewModel.address)

                        Button(NSLocalizedString("OK", comment: ""), action: {
                            fetchWeatherData()
                        })
                        Button(NSLocalizedString("Cancel", comment: ""), role: .cancel) {}
                    } message: {}
                }
                .padding(.top, 10)
                .tint(Color(UIColor.darkGray))

                Spacer()

                if let viewModel = weatherForecastViewModel {
                    CurrentWeatherView(address: viewModel.address, weatherViewModel: viewModel.currentWeather)
                        .padding(.bottom, 10)

                    ForecastView(forecastViewModel: viewModel)
                } else {
                    Text(NSLocalizedString("No weather forecast available", comment: ""))
                }
            }
            .alert(NSLocalizedString("Error", comment: ""), isPresented: .constant(weatherViewModel.fetchedWithError)) {
                Button(NSLocalizedString("OK", comment: ""), action: {
                    weatherViewModel.clearError()
                })
            } message: {
                let text = String(format: NSLocalizedString("Fetching weather forecast for %@ failed", comment: ""),
                                  weatherViewModel.address)
                Text(text)
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

private extension WeatherForecastView {

    func fetchWeatherData() {
        print("Fetching weather forecast for: \(weatherViewModel.address)")
        weatherViewModel.fetchWeatherData()
    }
}
