import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    private let field = UITextField()
    private let countLabel = UILabel()
    private let resultsTable = UITableView()
    private var results: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground

        field.placeholder = "Search products"
        field.borderStyle = .roundedRect
        field.returnKeyType = .search
        field.delegate = self
        field.accessibilityIdentifier = "search-input"

        countLabel.font = .preferredFont(forTextStyle: .headline)
        countLabel.accessibilityIdentifier = "result-count"

        resultsTable.dataSource = self
        resultsTable.register(UITableViewCell.self, forCellReuseIdentifier: "product")
        resultsTable.accessibilityIdentifier = "search-results"

        let stack = UIStackView(arrangedSubviews: [field, countLabel, resultsTable])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        showResults(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        results = search(textField.text ?? "")
        countLabel.text = "\(results.count) results"
        resultsTable.reloadData()
        showResults(true)
        textField.resignFirstResponder()
        return true
    }

    private func showResults(_ visible: Bool) {
        countLabel.isHidden = !visible
        resultsTable.isHidden = !visible
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productCell(tableView, results[indexPath.row], indexPath)
    }
}
