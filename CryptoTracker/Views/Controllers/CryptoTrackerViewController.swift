//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Вадим on 31.10.22.
//

import UIKit


class CryptoTrackerViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var viewModel: MVVMProtocolIn & MVVMProtocolOut
    
    init(viewModel: MVVMProtocolIn & MVVMProtocolOut) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        activityIndicator.startAnimating()
        viewModel.getAllCryptoData()
        listenViewModel()
    }
    
    private func configureView() {
        configureNavigationBar()
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Crypto Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.backward.square"),
            style: .done,
            target: self,
            action: #selector(logout)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .done,
            target: self,
            action: #selector(sortCryptos)
        )
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func listenViewModel() {
        viewModel.reloadTableView = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
        viewModel.showError = { [weak self] error in
            self?.activityIndicator.stopAnimating()
            self?.showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        let activityIndicatorConstraints = [
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    @objc func sortCryptos() {
        viewModel.sortCryptos()
        self.tableView.reloadData()
    }
    
    @objc func logout() {
        LoginManager.shared.logout()
    }
}

extension CryptoTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModel.cryptos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let crypto = viewModel.cryptos[indexPath.row]
        let detailViewController = DetailCryptoViewController(model: crypto)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
