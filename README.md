# WeatherForecast

Application utilizes Open-Meteo API (https://open-meteo.com) enabling to fulfill the requirements for free (especially obtaining 10 day forecast).

Technically two requests for data are performed: one for hourly forecast (including current weather) for short period and one for daily forecast. Responses are merged and provide data for view.

On app launch, it's necessary to press "gear" button to enter city name, which weather forecast is supposed to be fetched for. In case of arror last successfully fetched data is kept and displayed.
