

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tempLabel: UILabel!

    
    private var city: CityLocation?
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }

        func configure(with city: CityLocation, temperature: Double?) {
            self.city = city
            cityLabel.text = "\(city.name), \(city.country ?? "")"
            
            if let temp = temperature {
                tempLabel.text = "\(Int(temp))°C"
                tempLabel.isHidden = false
            } else {
                tempLabel.isHidden = true
            }
            
             
            updateLikeState()
        }

        @IBAction func likeTapped(_ sender: UIButton) {
            guard let city = city else { return }

            FavoriteManager.shared.toggleFavorite(city)
            updateLikeState()
        }

        private func updateLikeState() {
            guard let city = city else { return }

            let isFav = FavoriteManager.shared.isFavorite(city)
            let imageName = isFav ? "heart.fill" : "heart"

            likeButton.setImage(UIImage(systemName: imageName), for: .normal)
            likeButton.tintColor = isFav ? .systemRed : .systemBlue
        }

    
    private func setupCardStyle() {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = false

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = selected
                ? CGAffineTransform(scaleX: 0.97, y: 0.97)
                : .identity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCardStyle()
    }

}
