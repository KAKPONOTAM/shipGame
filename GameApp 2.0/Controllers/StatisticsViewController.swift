import UIKit

class StatisticsViewController: UIViewController {
    
    //MARK: - properties
    private let myTableView = UITableView()
    private var gameResultArray = [GameResults]()
    private let userDefaultsManager = UserDefaultsManager.shared
    private let idCell = "myCell"
    
    private let goBackToMainVCFromStatistics: UIButton = {
        let button = UIButton()
        let sizeForButton = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "arrow.backward.square.fill", withConfiguration: sizeForButton), for: .normal)
        button.addTarget(self, action: #selector(goBackToMain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let localizedResultsDescription = "your results".localized
        label.text = localizedResultsDescription
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        addSubView()
        addTableView()
        setupConstraints()
        guard let resultsArray = userDefaultsManager.receiveResults() else { return }
        gameResultArray = resultsArray
    }
    
    //MARK: - methods
    @objc private func goBackToMain() {
        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addTableView() {
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
        self.myTableView.translatesAutoresizingMaskIntoConstraints = false
        self.myTableView.backgroundColor = .gray
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            goBackToMainVCFromStatistics.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            goBackToMainVCFromStatistics.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            goBackToMainVCFromStatistics.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1 / 5),
            goBackToMainVCFromStatistics.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300)
        ])
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 150),
            topLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -150),
            topLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300)
        ])
        
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: self.topLabel.bottomAnchor, constant: 0),
            myTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            myTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
    private func addSubView() {
        self.view.addSubview(goBackToMainVCFromStatistics)
        self.view.addSubview(topLabel)
        self.view.addSubview(myTableView)
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        cell.backgroundColor = .gray
        cell.selectionStyle = .none
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(indexPath.row + 1). \(gameResultArray[indexPath.row].resultDate): \(gameResultArray[indexPath.row].result ?? "") points"
        cell.contentConfiguration = content
        
        return cell
    }
}


