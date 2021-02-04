import Foundation

struct Weather {
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
}

protocol WeatherServiceDelegate: AnyObject {
    func didFetchWeather(_ weatherService: WeatherService, weather: Weather)
    
}

struct WeatherService {
    
    var delegate: WeatherServiceDelegate?
    
    func fetchWeather(cityName: String) {
        let weather = Weather(cityName: "Chengdu", temperature: 13)
        delegate?.didFetchWeather(self, weather: weather) 
    
    }
}
