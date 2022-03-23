import UIKit

class SettingsViewController: UIViewController {
    //MARK: - properties
    private let difficultySelectionSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        let easyLvlLocalizedTitle = "easy".localized
        let midLvlLocalizedTitle = "mid".localized
        let hardLvlLocalizedTitle = "hard".localized
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.insertSegment(withTitle: easyLvlLocalizedTitle, at: 0, animated: false)
        segment.insertSegment(withTitle: midLvlLocalizedTitle, at: 1, animated: false)
        segment.insertSegment(withTitle: hardLvlLocalizedTitle, at: 2, animated: false)
        segment.backgroundColor = .black
        segment.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white.cgColor,
            .backgroundColor: UIColor.clear.cgColor],
                                       for: .normal)
        segment.selectedSegmentTintColor = .gray
        return segment
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "arrow.backward.square.fill", withConfiguration: buttonConfiguration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let difficultyLevelDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        let localizedDifficultySelection = "choose complexity".localized
        label.text = localizedDifficultySelection
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private let submarineSelectionSegmentedController: UISegmentedControl = {
        let segment = UISegmentedControl()
        
        let firstLocalizedSubmarineType = "first".localized
        let secondLocalizedSubmarineType = "second".localized
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.insertSegment(withTitle: firstLocalizedSubmarineType, at: 0, animated: false)
        segment.insertSegment(withTitle: secondLocalizedSubmarineType, at: 1, animated: false)
        segment.backgroundColor = .black
        segment.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white.cgColor,
            .backgroundColor: UIColor.clear.cgColor],
                                       for: .normal)
        segment.selectedSegmentTintColor = .gray
        segment.addTarget(self, action: #selector(changeAndSaveSubmarineImage), for: .valueChanged)
        return segment
    }()
    
    private let chooseObstaclesDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        let localizedObstaclesSelectionDescription = "choose obstacles".localized
        label.text = localizedObstaclesSelectionDescription
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private let chooseSubmarineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        let localizedSubmarineSelectionDescription = "choose submarine".localized
        label.text = localizedSubmarineSelectionDescription
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private let obstaclesSegmentedController: UISegmentedControl = {
        let segment = UISegmentedControl()
        
        let localizedFirstObstacleSelectionTitle = "fishes".localized
        let localizedSecondObstacleSelectionTitle = "jellyfish".localized
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.insertSegment(withTitle: localizedFirstObstacleSelectionTitle, at: 0, animated: false)
        segment.insertSegment(withTitle: localizedSecondObstacleSelectionTitle, at: 1, animated: false)
        segment.backgroundColor = .black
        segment.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.white.cgColor,
            .backgroundColor: UIColor.clear.cgColor],
                                       for: .normal)
        segment.selectedSegmentTintColor = .gray
        segment.addTarget(self, action: #selector(changeAndSaveObstaclesImage), for: .valueChanged)
        return segment
    }()
    
    private let submarinesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let obstaclesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        addSubview()
        setupConstraints()
    }
    
    //MARK: - methods
    private func addSubview() {
        view.addSubview(difficultySelectionSegmentControl)
        view.addSubview(submarineSelectionSegmentedController)
        view.addSubview(chooseSubmarineDescriptionLabel)
        view.addSubview(difficultyLevelDescriptionLabel)
        view.addSubview(obstaclesSegmentedController)
        view.addSubview(chooseObstaclesDescriptionLabel)
        view.addSubview(submarinesImageView)
        view.addSubview(exitButton)
        view.addSubview(obstaclesImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            difficultySelectionSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            difficultySelectionSegmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            difficultySelectionSegmentControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3),
            difficultySelectionSegmentControl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4)
        ])
        
        NSLayoutConstraint.activate([
            submarineSelectionSegmentedController.topAnchor.constraint(equalTo: difficultySelectionSegmentControl.bottomAnchor, constant: 20),
            submarineSelectionSegmentedController.leadingAnchor.constraint(equalTo: difficultySelectionSegmentControl.leadingAnchor),
            submarineSelectionSegmentedController.trailingAnchor.constraint(equalTo: difficultySelectionSegmentControl.trailingAnchor),
            submarineSelectionSegmentedController.heightAnchor.constraint(equalTo: difficultySelectionSegmentControl.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            obstaclesSegmentedController.topAnchor.constraint(equalTo: submarineSelectionSegmentedController.bottomAnchor, constant: 20),
            obstaclesSegmentedController.leadingAnchor.constraint(equalTo: submarineSelectionSegmentedController.leadingAnchor),
            obstaclesSegmentedController.trailingAnchor.constraint(equalTo: submarineSelectionSegmentedController.trailingAnchor),
            obstaclesSegmentedController.heightAnchor.constraint(equalTo: submarineSelectionSegmentedController.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            difficultyLevelDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            difficultyLevelDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            difficultyLevelDescriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3),
            difficultyLevelDescriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4)
        ])
        
        NSLayoutConstraint.activate([
            chooseSubmarineDescriptionLabel.topAnchor.constraint(equalTo: difficultyLevelDescriptionLabel.bottomAnchor, constant: 20),
            chooseSubmarineDescriptionLabel.leadingAnchor.constraint(equalTo: difficultyLevelDescriptionLabel.leadingAnchor),
            chooseSubmarineDescriptionLabel.trailingAnchor.constraint(equalTo: difficultyLevelDescriptionLabel.trailingAnchor),
            chooseSubmarineDescriptionLabel.heightAnchor.constraint(equalTo: difficultyLevelDescriptionLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chooseObstaclesDescriptionLabel.topAnchor.constraint(equalTo: chooseSubmarineDescriptionLabel.bottomAnchor, constant: 20),
            chooseObstaclesDescriptionLabel.leadingAnchor.constraint(equalTo: chooseSubmarineDescriptionLabel.leadingAnchor),
            chooseObstaclesDescriptionLabel.trailingAnchor.constraint(equalTo: chooseSubmarineDescriptionLabel.trailingAnchor),
            chooseObstaclesDescriptionLabel.heightAnchor.constraint(equalTo: chooseSubmarineDescriptionLabel.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            submarinesImageView.topAnchor.constraint(equalTo: submarineSelectionSegmentedController.topAnchor),
            submarinesImageView.leadingAnchor.constraint(equalTo: chooseSubmarineDescriptionLabel.trailingAnchor),
            submarinesImageView.trailingAnchor.constraint(equalTo: submarineSelectionSegmentedController.leadingAnchor),
            submarinesImageView.heightAnchor.constraint(equalTo: submarineSelectionSegmentedController.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            obstaclesImageView.topAnchor.constraint(equalTo: obstaclesSegmentedController.topAnchor),
            obstaclesImageView.leadingAnchor.constraint(equalTo: chooseObstaclesDescriptionLabel.trailingAnchor),
            obstaclesImageView.trailingAnchor.constraint(equalTo: obstaclesSegmentedController.leadingAnchor),
            obstaclesImageView.heightAnchor.constraint(equalTo: obstaclesSegmentedController.heightAnchor)
        ])
    }
    
    private func selectGameElementsIfUserDidntSelectAny() {
        submarineSelectionSegmentedController.selectedSegmentIndex = 0
        obstaclesSegmentedController.selectedSegmentIndex = 0
        
        guard let firstSubmarineImage = UIImage(named: "sub") else { return }
        submarinesImageView.image = firstSubmarineImage
        
        
        guard let fishImageView = UIImage(named: "shark") else { return }
        obstaclesImageView.image = fishImageView
    }
    
    @objc private func changeAndSaveSubmarineImage() {
        switch submarineSelectionSegmentedController.selectedSegmentIndex {
        case 0:
            guard let firstSubmarineImage = UIImage(named: "sub") else { return }
            submarinesImageView.image = firstSubmarineImage
            let savedImage = FileManager.saveImage(firstSubmarineImage)
            
            UserDefaults.standard.set(savedImage, forKey: UserDefaultsKeys.submarineKey)
            
        case 1:
            guard let secondSubmarineImage = UIImage(named: "secondsub") else { return }
            submarinesImageView.image = secondSubmarineImage
            
            let imageFileName = FileManager.saveImage(secondSubmarineImage)
            
            UserDefaults.standard.set(imageFileName, forKey: UserDefaultsKeys.submarineKey)
            
        default:
            guard let firstSubmarineImage = UIImage(named: "sub") else { return }
            submarinesImageView.image = firstSubmarineImage
            
            let imageFileName = FileManager.saveImage(firstSubmarineImage)
            
            UserDefaults.standard.set(imageFileName, forKey: UserDefaultsKeys.submarineKey)
        }
    }
    
    @objc private func changeAndSaveObstaclesImage() {
        switch obstaclesSegmentedController.selectedSegmentIndex {
        case 0:
            guard let fishImageView = UIImage(named: "shark") else { return }
            obstaclesImageView.image = fishImageView
            
            let imageFileName = FileManager.saveImage(fishImageView)
            
            UserDefaults.standard.set(imageFileName, forKey: UserDefaultsKeys.obstaclesKey)
            
        case 1:
            guard let jellyfishImageView = UIImage(named: "jf1") else { return }
            obstaclesImageView.image = jellyfishImageView
            
            let imageFileName = FileManager.saveImage(jellyfishImageView)
            
            UserDefaults.standard.set(imageFileName, forKey: UserDefaultsKeys.obstaclesKey)

        default:
            guard let fishImageView = UIImage(named: "shark") else { return }
            let imageFileName = FileManager.saveImage(fishImageView)
            
            UserDefaults.standard.set(imageFileName, forKey: UserDefaultsKeys.obstaclesKey)
        }
    }
    
    @objc private func exitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
