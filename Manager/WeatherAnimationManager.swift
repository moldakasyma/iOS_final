import UIKit

class WeatherAnimationManager {

    private var emitterLayer: CAEmitterLayer?

    // MARK: - Clear
    func clear(from view: UIView) {
        emitterLayer?.removeFromSuperlayer()
        emitterLayer = nil

        view.subviews.forEach {
            if $0 is UIImageView {
                $0.removeFromSuperview()
            }
        }
    }

    // MARK: - Rain
    func showRain(on view: UIView) {
        clear(from: view)

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)

        let cell = CAEmitterCell()
        cell.birthRate = 120
        cell.lifetime = 4
        cell.velocity = 400
        cell.velocityRange = 100
        cell.scale = 0.2
        cell.emissionLongitude = .pi

        cell.contents = coloredImage(
            systemName: "drop.fill",
            color: .systemBlue
        )

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        emitterLayer = emitter
    }

    // MARK: - Snow
    func showSnow(on view: UIView) {
        clear(from: view)

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)

        let cell = CAEmitterCell()
        cell.birthRate = 30
        cell.lifetime = 10
        cell.velocity = 40
        cell.velocityRange = 20
        cell.scale = 0.12
        cell.scaleRange = 0.05
        cell.spinRange = .pi
        cell.emissionRange = .pi

        cell.contents = coloredImage(
            systemName: "snowflake",
            color: .white
        )

        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        emitterLayer = emitter
    }

    // MARK: - Clouds
    func showClouds(on view: UIView) {
        clear(from: view)

        let cloud = UIImageView(image: UIImage(systemName: "cloud.fill"))
        cloud.tintColor = .white
        cloud.alpha = 0.4
        cloud.frame = CGRect(x: -200, y: 120, width: 200, height: 100)

        view.addSubview(cloud)

        UIView.animate(
            withDuration: 30,
            delay: 0,
            options: [.repeat, .curveLinear],
            animations: {
                cloud.frame.origin.x = view.bounds.width + 200
            }
        )
    }

    // MARK: - Sun
    func showSun(on view: UIView) {
        clear(from: view)

        let sun = UIImageView(image: UIImage(systemName: "sun.max.fill"))
        sun.tintColor = .systemYellow
        sun.frame = CGRect(x: view.bounds.width - 120, y: 100, width: 80, height: 80)

        view.addSubview(sun)

        UIView.animate(
            withDuration: 6,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                sun.transform = CGAffineTransform(rotationAngle: .pi / 6)
            }
        )
    }

    // MARK: - Helper (ВАЖНО для цвета)
    private func coloredImage(
        systemName: String,
        color: UIColor,
        size: CGSize = CGSize(width: 20, height: 20)
    ) -> CGImage? {

        let config = UIImage.SymbolConfiguration(pointSize: size.width)
        let image = UIImage(systemName: systemName, withConfiguration: config)?
            .withTintColor(color, renderingMode: .alwaysOriginal)

        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { _ in
            image?.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderedImage.cgImage
    }
}
