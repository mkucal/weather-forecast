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

                if let viewModel = weatherViewModel.weatherForecastViewModel {
                    CurrentWeatherView(address: viewModel.address, weatherViewModel: viewModel.currentWeather)
                        .padding(.bottom, 10)

                    ForecastView(forecastViewModel: viewModel)
                        .background(Color(UIColor.systemGroupedBackground))
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

struct CurrentWeatherView: View {

    let address: String
    let weatherViewModel: CurrentWeatherViewModel?

    var body: some View {
        VStack(spacing: 10) {
            Text(address)
                .font(.title2)
            Text(weatherViewModel?.temperature ?? "")
                .font(.system(size: 50))
            Image(systemName: weatherViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Text(weatherViewModel?.weatherStateDesc ?? "")
                .font(.callout)
        }
    }
}

struct ForecastView: View {

    let forecastViewModel: WeatherForecastViewModel?

    var body: some View {
        List {
            Section("Hourly forecast") {
                HourlyForecastView(forecastViewModel: forecastViewModel?.hourlyForecast)
                    .padding(.vertical, 10)
            }

            Section("10 day forecast") {
                let data = forecastViewModel?.dailyForecast?.data ?? []
                ForEach(0..<data.count, id: \.self) { index in
                    DailyForecastItemView(forecastViewModel: data[index])
                }
            }
        }
    }
}

struct HourlyForecastView: View {

    let forecastViewModel: HourlyForecastViewModel?

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                let data = forecastViewModel?.data ?? []
                ForEach(0..<data.count, id: \.self) { index in
                    HourlyForecastItemView(forecastViewModel: data[index])
                }
            }
        }
    }
}

struct HourlyForecastItemView: View {

    let forecastViewModel: SpecifiedHourForecastViewModel?

    var body: some View {
        VStack(spacing: 4) {
            Text(forecastViewModel?.time ?? "")
            Image(systemName: forecastViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Text(forecastViewModel?.temperature ?? "")
        }
        .padding(.vertical, 10)
        .frame(width: 90)
        .background(.gray)
        .cornerRadius(8)
    }
}

struct DailyForecastItemView: View {

    let forecastViewModel: SpecifiedDayForecastViewModel?

    var body: some View {
        HStack {
            Text(forecastViewModel?.date ?? "")
                .font(.callout)
                .padding(.vertical, 10)
                .frame(maxWidth: 100, alignment: .leading)
                .background(.white)
            Spacer()
            Image(systemName: forecastViewModel?.weatherStateIconName ?? "")
                .font(.title2)
            Spacer()

            let temperatureStr = (forecastViewModel?.temperatureMin ?? "")
            + " / " + (forecastViewModel?.temperatureMax ?? "")
            Text(temperatureStr)
                .frame(maxWidth: 120, alignment: .trailing)
                .background(.white)
        }
    }
}

struct ActivityIndicatorView: View {

    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(width: 120, height: 120)
            .background(.gray)
            .cornerRadius(8)
    }
}
