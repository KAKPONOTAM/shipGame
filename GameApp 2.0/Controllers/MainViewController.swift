import UIKit

class MainViewController: UIViewController {
    //MARK: - properties
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let sizeForButton = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: sizeForButton), for: .normal)
        button.addTarget(self, action: #selector(showGameVC), for: .touchUpInside)
        button.defaultShadowSetup()
        return button
    }()

    private let statisticsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let sizeForButton = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "chart.bar.xaxis", withConfiguration: sizeForButton), for: .normal)
        button.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        button.defaultShadowSetup()
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        let sizeForButton = UIImage.SymbolConfiguration(pointSize: 45, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "slider.horizontal.3", withConfiguration: sizeForButton), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        button.defaultShadowSetup()
        return button
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let localizedGameName = "submarine game".localized
        label.text = localizedGameName
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        addSubView()
        setupConstraints()
    }
    
    //MARK: - methods
    private func addSubView() {
        self.view.addSubview(playButton)
        self.view.addSubview(statisticsButton)
        self.view.addSubview(settingsButton)
        self.view.addSubview(gameNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 7),
            settingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
        
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4),
            playButton.trailingAnchor.constraint(equalTo: statisticsButton.leadingAnchor, constant: -150),
            playButton.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 150),
            playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
        
        NSLayoutConstraint.activate([
            statisticsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 4),
            statisticsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            statisticsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 7),
            statisticsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            gameNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            gameNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            gameNameLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -50)
        ])
    }
    
    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        present(settingsVC, animated: true, completion: nil)
    }

    @objc private func showGameVC() {
        let gameVC = GameViewController()
        gameVC.modalTransitionStyle = .crossDissolve
        gameVC.modalPresentationStyle = .fullScreen

        self.present(gameVC, animated: true, completion: nil)
    }

    @objc private func showResults() {
        let statisticsVC = StatisticsViewController()
        statisticsVC.modalPresentationStyle = .fullScreen
        present(statisticsVC, animated: true, completion: nil)
    }
}

