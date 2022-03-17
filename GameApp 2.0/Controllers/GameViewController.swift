import UIKit
import CoreMotion

class GameViewController: UIViewController {
    //MARK: - properties
    private var counter = 0
    private var intersectionCheckTimer = Timer()
    private var counterTimer = Timer()
    private var animatorForShipImageView: UIViewPropertyAnimator?
    private var animatorForFishImageView: UIViewPropertyAnimator?
    private var gameResultArray = [GameResults]()
    private let dateFormatter = DateFormatter()
    private let date = Date.now
    private let userDefaultsManager = UserDefaultsManager.shared
    private let coreMotionManager = CMMotionManager()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "back")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let shipsImagesArray: [UIImage] = {
        var array = [UIImage]()
        
        guard let firstShip = UIImage(named: "firstship"),
              let secondShip = UIImage(named: "secondship"),
              let thirdShip = UIImage(named: "thirdship") else { return array }
        
        array += [firstShip, secondShip, thirdShip]
        
        return array
    }()
    
    private let boomImageView: UIImageView = {
        let image = UIImageView()
        guard let boomImage = UIImage(named: "boom") else { return image }
        image.image = boomImage
        return image
    }()
    
    private let shipsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var submarineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 10, y: view.frame.size.height / 2, width: 150, height: 75)
        imageView.image = UIImage(named: "sub")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        return imageView
    }()
    
    private let obstaclesImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: buttonConfiguration), for: .normal)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonUp: UIButton = {
        let button = UIButton()
        let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonUpTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrowtriangle.up.square", withConfiguration: buttonConfiguration), for: .normal)
        button.tintColor = .green
        return button
    }()
    
    private let buttonDown: UIButton = {
        let button = UIButton()
        let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "arrowtriangle.down.square", withConfiguration: buttonConfiguration), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(buttonDownTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var shakeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x: 10, y: 10, width: view.frame.width - 10, height: 30)
        label.text = "Shake phone to start the game"
        return label
    }()
    
    deinit {
        intersectionCheckTimer.invalidate()
        counterTimer.invalidate()
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        addSubview()
        setupConstraints()
        beginGameWithGyro()
    }
    
    //MARK: - methods
    private func addSubview() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.addSubview(exitButton)
        backgroundImageView.addSubview(buttonUp)
        backgroundImageView.addSubview(buttonDown)
        backgroundImageView.addSubview(scoreLabel)
        backgroundImageView.addSubview(obstaclesImageView)
        backgroundImageView.addSubview(shipsImageView)
        backgroundImageView.addSubview(submarineImageView)
        backgroundImageView.addSubview(boomImageView)
        backgroundImageView.addSubview(shakeDescriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            exitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 10),
            exitButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 6)
        ])
        
        NSLayoutConstraint.activate([
            buttonUp.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 1 / 7),
            buttonUp.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -50),
            buttonUp.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 1 / 10),
            buttonUp.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -70)
        ])
        
        NSLayoutConstraint.activate([
            buttonDown.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 1 / 7),
            buttonDown.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 50),
            buttonDown.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 1 / 10),
            buttonDown.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -70)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 1 / 7),
            scoreLabel.leadingAnchor.constraint(equalTo: buttonDown.trailingAnchor, constant: 100),
            scoreLabel.trailingAnchor.constraint(equalTo: buttonUp.leadingAnchor, constant: -100),
            scoreLabel.bottomAnchor.constraint(equalTo: buttonUp.bottomAnchor)
        ])
    }
    
    private func beginGameWithGyro() {
        if coreMotionManager.isGyroAvailable {
            coreMotionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                guard let gyro = data?.rotationRate else { return }
                
                if gyro.y >= 2 && gyro.z >= 1 {
                    self?.shakeDescriptionLabel.isHidden = true
                    self?.submarineImageView.isHidden = false
                    self?.gameStarted()
                }
            }
        } else {
            let alert = UIAlertController(title: "Gyro is not available", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func gameStarted() {
        if let submarineImageFilename = UserDefaults.standard.object(forKey: UserDefaultsKeys.submarineKey) as? String,
           let obstacleImageFilename = UserDefaults.standard.object(forKey: UserDefaultsKeys.obstaclesKey) as? String {
            shipsImageView.image = shipsImagesArray.randomElement()
            
            let loadedSubmarineImage = FileManager.loadImage(fileName: submarineImageFilename)
            let loadedObstacleImage = FileManager.loadImage(fileName: obstacleImageFilename)
            
            submarineImageView.image = loadedSubmarineImage
            obstaclesImageView.image = loadedObstacleImage
            
            counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(activateCounterTimer), userInfo: nil, repeats: true)
            counterTimer.fire()
            
            self.intersectionCheckTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(intersectionCheck), userInfo: nil, repeats: true)
            
            intersectionCheckTimer.fire()
            
        } else {
            
            shipsImageView.image = shipsImagesArray.randomElement()
            submarineImageView.image = UIImage(named: "sub")
            obstaclesImageView.image = UIImage(named: "shark")
            
            counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(activateCounterTimer), userInfo: nil, repeats: true)
            counterTimer.fire()
            
            self.intersectionCheckTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(intersectionCheck), userInfo: nil, repeats: true)
            
            intersectionCheckTimer.fire()
    }
}
    
    @objc private func exitButtonTapped() {
        switch counter {
        case 0:
            dismiss(animated: true, completion: nil)
            intersectionCheckTimer.invalidate()
            counterTimer.invalidate()
            counter = 0
            
        default:
            animatorForFishImageView?.pauseAnimation()
            animatorForShipImageView?.pauseAnimation()
            
            intersectionCheckTimer.invalidate()
            counterTimer.invalidate()
            
            let localizedAlertTitle = "Do you really want to exit the game?".localized
            let localizedAlertMessage = "your results will nullified".localized
            
            let alert = UIAlertController(title: localizedAlertTitle, message: localizedAlertMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.animatorForFishImageView?.stopAnimation(true)
                self?.animatorForShipImageView?.stopAnimation(true)
                self?.dismiss(animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
                self?.animatorForShipImageView?.startAnimation()
                self?.animatorForFishImageView?.startAnimation()
                
                self?.intersectionCheckTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self ?? GameViewController(), selector: #selector(self?.intersectionCheck), userInfo: nil, repeats: true)
                self?.intersectionCheckTimer.fire()
                
                self?.counterTimer = Timer.scheduledTimer(timeInterval: 1, target: self ?? GameViewController(), selector: #selector(self?.activateCounterTimer), userInfo: nil, repeats: true)
                self?.counterTimer.fire()
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func activateCounterTimer() {
        let initialOriginX = view.frame.maxX
        let finalOriginX = view.frame.minX
        
        counter += 1
        scoreLabel.text = "\(counter)"
        
        if counter.isMultiple(of: 10) {
            shipsImageView.frame = CGRect(x: initialOriginX + shipsImageView.frame.width, y: 10, width: 75, height: 75)
            
            animatorForShipImageView = UIViewPropertyAnimator(duration: 5, curve: .linear, animations: {
                self.shipsImageView.frame.origin.x = finalOriginX - self.shipsImageView.frame.width
            })
            
            animatorForShipImageView?.startAnimation()
            
        } else if counter.isMultiple(of: 7) {
            obstaclesImageView.frame = CGRect(x: initialOriginX + obstaclesImageView.frame.width, y: .random(in: view.frame.minY ... view.frame.maxY + 50), width: 75, height: 75)
            
            animatorForFishImageView = UIViewPropertyAnimator(duration: 5, curve: .linear, animations: {
                self.obstaclesImageView.frame.origin.x = finalOriginX - self.obstaclesImageView.frame.width
            })
            
            animatorForFishImageView?.startAnimation()
        }
    }
    
    @objc private func intersectionCheck() {
        guard let shipsImageView = shipsImageView.layer.presentation(),
              let submarineImageView = submarineImageView.layer.presentation(),
              let fishImageView = obstaclesImageView.layer.presentation() else { return }
        
        guard let result = scoreLabel.text else { return }
        
        if submarineImageView.frame.intersects(fishImageView.frame) ||
            fishImageView.frame.intersects(submarineImageView.frame) ||
            
            submarineImageView.frame.intersects(shipsImageView.frame) ||
            shipsImageView.frame.intersects(submarineImageView.frame) {
            
            boomImageView.frame = CGRect(x: self.submarineImageView.frame.origin.x, y: self.submarineImageView.frame.origin.y , width: self.submarineImageView.frame.width, height: self.submarineImageView.frame.height + 50)
            
            self.obstaclesImageView.removeFromSuperview()
            self.submarineImageView.removeFromSuperview()
            self.shipsImageView.removeFromSuperview()
            
            dateFormatter.dateFormat = "d MM YYYY,h:mm:ss a"
            let dateString = dateFormatter.string(from: date)
            
            let gameResults = GameResults(result: result, resultDate: dateString)
          
            userDefaultsManager.saveResults(results: gameResults)
            
            let localizedGameOverText = "GAME OVER".localized
            
            scoreLabel.text = localizedGameOverText
            intersectionCheckTimer.invalidate()
            counterTimer.invalidate()
            counter = 0
        }
    }
    
    @objc private func buttonUpTapped() {
        UIView.animate(withDuration: 0.3) {
            self.submarineImageView.frame.origin.y -= 50
            
            if self.submarineImageView.frame.origin.y <= self.view.frame.minY - self.submarineImageView.frame.height / 1.5 {
                self.buttonDownTapped()
            }
        }
    }
    
    @objc private func buttonDownTapped() {
        UIView.animate(withDuration: 0.3) {
            self.submarineImageView.frame.origin.y += 50
            
            if self.submarineImageView.frame.origin.y >= self.view.frame.maxY - self.submarineImageView.frame.height / 1.5 {
                self.buttonUpTapped()
            }
        }
    }
}
