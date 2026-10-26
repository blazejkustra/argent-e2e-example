import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    private let field = UITextField()
    private let suggestions = UIStackView()
    private let summary = UIStackView()
    private let countLabel = makeLabel("", Theme.font(15, .semibold), Theme.muted)
    private let resultsList = makeStack([], axis: .vertical, spacing: 12)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.canvas

        field.placeholder = "Shoes, apparel, gear"
        field.font = Theme.font(17, .medium)
        field.textColor = Theme.ink
        field.returnKeyType = .search
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.delegate = self
        field.accessibilityIdentifier = "search-input"

        countLabel.accessibilityIdentifier = "result-count"
        resultsList.accessibilityIdentifier = "search-results"

        let content = makeStack([
            makeLabel("Search", Theme.font(32, .heavy)),
            searchBar(),
            suggestionsSection(),
            resultsSummary(),
            resultsList,
        ], axis: .vertical, spacing: 16)
        content.setCustomSpacing(22, after: content.arrangedSubviews[1])
        _ = pageScrollView(content: content, in: view)
        showResults(false)
    }

    private func searchBar() -> UIView {
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = Theme.muted
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        icon.setContentHuggingPriority(.required, for: .horizontal)

        let row = makeStack([icon, field], axis: .horizontal, spacing: 10)
        row.alignment = .center
        row.isLayoutMarginsRelativeArrangement = true
        row.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 12)
        row.backgroundColor = .white
        row.layer.cornerRadius = 16
        addSoftShadow(to: row)
        row.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return row
    }

    private func suggestionsSection() -> UIView {
        let chips = ["running shoes", "trail", "headphones"].map(suggestionChip)
        let row = makeStack(chips + [UIView()], axis: .horizontal, spacing: 8)
        suggestions.axis = .vertical
        suggestions.spacing = 12
        suggestions.addArrangedSubview(makeLabel("Popular searches", Theme.font(17, .bold)))
        suggestions.addArrangedSubview(row)
        return suggestions
    }

    private func suggestionChip(_ text: String) -> UIView {
        var config = UIButton.Configuration.filled()
        config.title = text
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white
        config.baseForegroundColor = Theme.ink
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = Theme.font(14, .medium)
            return attributes
        }
        let chip = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
            self?.field.text = text
            self?.runSearch()
        })
        chip.setContentCompressionResistancePriority(.required, for: .horizontal)
        addSoftShadow(to: chip)
        return chip
    }

    private func resultsSummary() -> UIView {
        let sort = makeLabel("Best match", Theme.font(15, .semibold), Theme.brand)
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down"))
        chevron.tintColor = Theme.brand
        chevron.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        summary.axis = .horizontal
        summary.spacing = 4
        summary.alignment = .center
        [countLabel, UIView(), sort, chevron].forEach(summary.addArrangedSubview)
        return summary
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        runSearch()
        return true
    }

    private func runSearch() {
        let results = search(field.text ?? "")
        countLabel.text = "\(results.count) items"
        resultsList.arrangedSubviews.forEach { $0.removeFromSuperview() }
        results.map(ResultRowView.init).forEach(resultsList.addArrangedSubview)
        showResults(true)
        field.resignFirstResponder()
    }

    private func showResults(_ visible: Bool) {
        suggestions.isHidden = visible
        summary.isHidden = !visible
        resultsList.isHidden = !visible
    }
}
