//
//  ApiWorker.swift
//  WeatherForecast
//
//  Created by Michał Kucal on 18/05/2023.
//

import Foundation

protocol ApiWorkerProtocol {

}

class ApiWorker {

    func fetchWeatherData() {

    }
}


/*
 Current weather + hourly for 2 days

 https://api.open-meteo.com/v1/forecast?latitude=52.41&longitude=16.93&hourly=temperature_2m,relativehumidity_2m,apparent_temperature,precipitation,weathercode,surface_pressure,windspeed_10m,winddirection_10m&current_weather=true&forecast_days=2&timezone=Europe/Warsaw

 Forecast for 10 days (including today)

 https://api.open-meteo.com/v1/forecast?latitude=52.41&longitude=16.93&daily=weathercode,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum&timezone=Europe/Warsaw&forecast_days=10
 */
