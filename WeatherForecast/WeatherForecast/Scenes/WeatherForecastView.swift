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
            HStack(spacing: 20) {
                Spacer()

                Button(action: {

                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading, 20)
                }

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

            VStack(spacing: 10) {
                Text("Poznań")
                    .font(.title2)
                Text("20℃")
                    .font(.largeTitle)
                Image(systemName: "cloud")
                    .font(.title3)
                Text("Partly cloudly")
                    .font(.callout)
            }

            List {
                Section("Hourly forecast") {
                    ScrollView(.horizontal) {
                        HStack {
                            Text("First Row")
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                            Text("Second Row")
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                            Text("Third Row")
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                            Text("Fourth Row")
                                .padding()
                                .background(.white)
                                .cornerRadius(8)
                        }
                        .padding(.all, 8)
                    }
                }

                Section("10 day forecast") {
                    Text("Today")
                    Text("Sunday")
                    Text("Today")
                    Text("Sunday")
                    Text("Today")
                    Text("Sunday")
                    Text("Today")
                    Text("Sunday")
                    Text("Today")
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
