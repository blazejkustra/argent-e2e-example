import UIKit

class HomeViewController: UITableViewController {
    private let featured = Array(catalog.prefix(3))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shop"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.accessibilityIdentifier = "home-screen"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "product")

        let search = UIBarButtonItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            target: self,
            action: #selector(openSearch)
        )
        search.accessibilityIdentifier = "search-tab"
        toolbarItems = [.flexibleSpace(), search, .flexibleSpace()]
    }

    @objc private func openSearch() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Featured"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        featured.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productCell(tableView, featured[indexPath.row], indexPath)
    }
}

func productCell(_ tableView: UITableView, _ product: Product, _ indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath)
    var content = UIListContentConfiguration.valueCell()
    content.text = product.name
    content.secondaryText = product.price
    cell.contentConfiguration = content
    return cell
}
