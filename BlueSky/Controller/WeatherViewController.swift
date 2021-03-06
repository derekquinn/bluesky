import UIKit
import CoreLocation
import QuartzCore

class WeatherViewController: UIViewController {
    
    var weatherService = WeatherService()
    let locationManager = CLLocationManager()
    
    let rootStackView = UIStackView()
    
    // UIElements: Search
    let searchStackView = UIStackView()
    let locationButton = UIButton()
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
    // UIElements: Weather conditions
    let conditionImageView = UIImageView()
    let temperatureLabel = UILabel()
    let cityLabel = UILabel()
    
    // UI Element: Background image
    let backgroundView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setStyles()
        configureLayout()
        self.locationPressed(locationButton)
    }
    
}

extension WeatherViewController {
    
    func setupDelegates() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherService.delegate = self
        searchTextField.delegate = self
    }
    
    func setStyles() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.alignment = .trailing
        rootStackView.spacing = 10
        
        // Search (Text entry)
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.spacing = 8
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationPressed(_:)), for: .primaryActionTriggered)
        locationButton.tintColor = .label
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        searchTextField.placeholder = "Enter a City"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchPressed(_:)), for: .primaryActionTriggered)
        searchButton.tintColor = .label
        
        // Weather Conditions
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.tintColor = .label
        
        // Temperature Label
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        
        // City Label
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // Background Image
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.contentMode = .scaleAspectFill
        // Create a back view with color and alpha you need
        let backView = UIView(frame: backgroundView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        backgroundView.addSubview(backView)
        backgroundView.alpha = 0.3
    }
    
    private func makeTemperatureText(with temperature: String) -> NSAttributedString {
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 100)
        
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.systemFont(ofSize: 80)
        
        let weatherText = NSMutableAttributedString(string: temperature, attributes: boldTextAttributes)
        weatherText.append(NSAttributedString(string: "°C", attributes: plainTextAttributes))
        
        return weatherText
    }
    
    func configureLayout() {
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        rootStackView.addArrangedSubview(searchStackView)
        rootStackView.addArrangedSubview(conditionImageView)
        rootStackView.addArrangedSubview(temperatureLabel)
        rootStackView.addArrangedSubview(cityLabel)
        
        view.addSubview(backgroundView)
        view.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            
            searchStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            
            locationButton.heightAnchor.constraint(equalToConstant: LocalSpacing.buttonSizeSmall),
            locationButton.widthAnchor.constraint(equalToConstant: LocalSpacing.buttonSizeSmall),
            
            searchButton.heightAnchor.constraint(equalToConstant: LocalSpacing.buttonSizeSmall),
            searchButton.widthAnchor.constraint(equalToConstant: LocalSpacing.buttonSizeSmall),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: LocalSpacing.buttonSizelarge),
            conditionImageView.widthAnchor.constraint(equalToConstant: LocalSpacing.buttonSizelarge),
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @objc func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a location"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherService.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherService.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherServiceDelegate {
    
    func didFetchWeather(_ weatherService: WeatherService, _ weather: WeatherModel) {
        self.temperatureLabel.attributedText = self.makeTemperatureText(with: weather.temperatureString)
        self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        self.cityLabel.text = weather.cityName
        
        /// Dynamic background
        UIView.transition(with: backgroundView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundView.image = UIImage(named: weather.backgroundImage) },
                          completion: nil)
        
        //self.backgroundView.image = UIImage(named: weather.backgroundImage)
        print("DEBUG - background image = \(weather.backgroundImage)")
    }
    
    func didFailWithError(_ weatherService: WeatherService, _ error: ServiceError) {
        let message: String
        
        switch error {
        case .network(statusCode: let statusCode):
            message = "[Error] Status code: \(statusCode)."
        case .parsing:
            message = "[Error] JSON weather data could not be parsed."
        case .general(reason: let reason):
            message = reason
        }
        showErrorAlert(with: message)
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error fetching weather from open sky network.",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


private struct LocalSpacing {
    static let buttonSizeSmall = CGFloat(44)
    static let buttonSizelarge = CGFloat(120)
}
