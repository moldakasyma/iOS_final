import UIKit

class AnimalsViewController: ViewController {

    @IBOutlet weak var pandaButton: UIButton!
    @IBOutlet weak var tigerButton: UIButton!
    @IBOutlet weak var foxyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelection()
    }

    @IBAction func pandaTapped(_ sender: UIButton) {
        AnimalManager.shared.setAnimal(.panda)
        updateSelection()
    }

    @IBAction func tigerTapped(_ sender: UIButton) {
        AnimalManager.shared.setAnimal(.tiger)
        updateSelection()
    }

    @IBAction func foxyTapped(_ sender: UIButton) {
        AnimalManager.shared.setAnimal(.foxy)
        updateSelection()
    }

    private func updateSelection() {
        let selected = AnimalManager.shared.getSelectedAnimal()

        pandaButton.alpha = selected == .panda ? 1.0 : 0.5
        tigerButton.alpha = selected == .tiger ? 1.0 : 0.5
        foxyButton.alpha = selected == .foxy ? 1.0 : 0.5
    }
}
