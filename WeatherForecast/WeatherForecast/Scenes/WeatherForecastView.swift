//
//  WeatherForecastView.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import SwiftUI
import CoreLocation
import Hydra

struct WeatherForecastView: View {

    @ObservedObject private var weatherViewModel = WeatherViewModel()

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

                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 10)

            Spacer()

            CurrentWeatherView()
                .padding(.bottom, 10)

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
            .background(Color(UIColor.systemGroupedBackground))
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
