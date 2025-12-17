import UIKit

class ViewController: UIViewController {
    
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
    }
    
    func setupGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer!.frame = view.bounds
        
        // Настройте цвета как хотите
        gradientLayer!.colors = [
                    UIColor(red: 0.39, green: 0.71, blue: 0.98, alpha: 1.0).cgColor, // #64B4FA
                    UIColor(red: 0.71, green: 0.59, blue: 0.86, alpha: 1.0).cgColor  // #B496DC
                ]
        
        gradientLayer!.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer!.endPoint = CGPoint(x: 0.5, y: 1)
        
        // Добавляем как самый нижний слой
        view.layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}


