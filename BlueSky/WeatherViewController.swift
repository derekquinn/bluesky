import UIKit

class WeatherViewController: UIViewController {
    
    let backgroundView = UIImageView()
    
    let searchStackView = UIStackView()
    let locationButton = UIButton()
    let searchButton = UIButton()
    let searchTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
    }
}


extension WeatherViewController {
    
    func style(){
        /// Background view
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named:"background")
        backgroundView.contentMode = .scaleToFill
        
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.spacing = 8
//        searchStackView.axis = .horizontal /// Default is horizontal, this is not needed
        
        /// Location Button
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        locationButton.tintColor = .label
        
        /// Search Button
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .label
        
        /// Search Bar
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        searchTextField.placeholder = "Search"
        searchTextField.textAlignment = .right
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .systemFill
    }
    
    func layout(){
        
        view.addSubview(backgroundView)
        view.addSubview(searchStackView)
        view.addSubview(locationButton)
        view.addSubview(searchButton)
        view.addSubview(searchTextField)

        
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            /// Using safeAreaLayoutGuide to account for landscape & portrait modes
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchStackView.trailingAnchor, multiplier: 1),

            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),

            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
    }
}
