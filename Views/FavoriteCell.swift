import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func didRemoveFavorite(_ city: FavoriteCity)
}

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    private var city: FavoriteCity?
    
    weak var delegate: FavoriteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupCardStyle()
    }
        
    func configure(with city: FavoriteCity) {
        self.city = city
        cityLabel.text = "\(city.name), \(city.country ?? "")"
        removeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        removeButton.tintColor = .red
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
        
    @IBAction func removeTapped(_ sender: UIButton) {
        guard let city = city else { return }
        delegate?.didRemoveFavorite(city)
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        cityLabel.text = nil
        city = nil
        delegate = nil
    }
    
//    func configure(with city: FavoriteCity) {
//        self.city = city
//        cityLabel.text = "\(city.name), \(city.country ?? "")"
//        removeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        removeButton.tintColor = .red
//    }
//    
//    @IBAction func removeTapped(_ sender: UIButton) {
////        guard let city = city else { return }
////        
////        FavoriteManager.shared.removeFavorite(city)
////        
////        // Just show a simple alert
////        if let tableView = superview as? UITableView,
////           let indexPath = tableView.indexPath(for: self) {
////            
////            // Remove from table with animation
////            if let vc = tableView.delegate as? FavoriteViewController {
////                vc.favorites.remove(at: indexPath.row)
////                tableView.deleteRows(at: [indexPath], with: .automatic)
////            }
////        }
//        guard let city = city else { return }
//        FavoriteManager.shared.removeFavorite(city)
//        delegate?.didRemoveFavorite(city)
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        cityLabel.text = nil
//        city = nil
//    }
}
