import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    let backgroundView = UIImageView()
    
    let rootStackView = UIStackView()
    
    /// Search Area
    let searchStackView = UIStackView()
    let locationButton = UIButton()
    let searchButton = UIButton()
    let searchTextField = UITextField()
    
    /// Weather Area
    let conditionImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        style()
        layout()
        
    }
}


extension WeatherViewController {
    
    func setup(){
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func style(){
        /// Background view
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named:"background")
        backgroundView.contentMode = .scaleToFill
        
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.alignment = .trailing
        rootStackView.spacing = 10
        
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.spacing = 8
//        searchStackView.axis = .horizontal /// Default is horizontal, this is not needed
        
        /// Location Button
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationPressed(_:)), for: .primaryActionTriggered)
        locationButton.tintColor = .label
        
        /// Search Button
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        /// Call searchPresed() when user presses enter / finishes typing
        searchButton.addTarget(self, action: #selector(searchPressed(_:)), for: .primaryActionTriggered)
        searchButton.tintColor = .label
        
        /// Search Bar
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill
        
        /// Weather Image
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.image = UIImage(systemName: "sun.max")
        conditionImageView.tintColor = .label
        
        /// Temp & City Labels
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.attributedText = makeTemperatureText(with: "20")
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        cityLabel.text = "Lansing"
        
    }
    
    private func makeTemperatureText(with temperature: String) -> NSAttributedString {
        /// Creating dictionary of key:value pairs and then setting properties on attributed text
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 100)
        
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.systemFont(ofSize: 80)
        
        let text = NSMutableAttributedString(string: temperature, attributes: boldTextAttributes)
        text.append(NSAttributedString(string:"ºC", attributes: plainTextAttributes))
        
        return text
    }
    
    func layout(){
        
        view.addSubview(backgroundView)
        view.addSubview(rootStackView)
        view.addSubview(searchStackView)
        view.addSubview(locationButton)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)

        rootStackView.addArrangedSubview(searchStackView) /// Stack view embedded in another UIStackView
        rootStackView.addArrangedSubview(conditionImageView)
        rootStackView.addArrangedSubview(temperatureLabel)
        rootStackView.addArrangedSubview(cityLabel)
        rootStackView.addArrangedSubview(temperatureLabel)
         
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            /// Settings applied to stack views to avoid adding individual constraints to child UI elements
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            searchStackView.widthAnchor.constraint(equalTo: rootStackView.widthAnchor),
            
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),

            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120)
            
        ])
        
    }
}

// MARK: UITextFieldDelegate

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
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
           // weatherService.fetchWeather(cityName: city)
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
          //  weatherService.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

