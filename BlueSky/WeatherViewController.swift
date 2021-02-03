import UIKit

class WeatherViewController: UIViewController {

    let backgroundView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
    }
}


extension WeatherViewController {
    
    func style(){
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named:"background")
        backgroundView.contentMode = .scaleToFill
    }
    
    func layout(){
        
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}
