import UIKit

class HomeViewController: UIViewController {
    private let featured = [catalog[0], catalog[1], catalog[3], catalog[4]]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.canvas

        let content = makeStack([
            header(),
            HeroBannerView(),
            sectionTitle("Categories", action: nil),
            categories(),
            sectionTitle("Popular this week", action: "See all"),
            productGrid(),
        ], axis: .vertical, spacing: 16)
        content.setCustomSpacing(22, after: content.arrangedSubviews[1])
        content.setCustomSpacing(22, after: content.arrangedSubviews[3])

        let scroll = pageScrollView(content: content, in: view)
        scroll.accessibilityIdentifier = "home-screen"
    }

    private func header() -> UIView {
        let greeting = makeStack([
            makeLabel("Good morning, Alex", Theme.font(15, .medium), Theme.muted),
            makeLabel("Stride", Theme.font(32, .heavy)),
        ], axis: .vertical, spacing: 2)

        let bell = UIButton(type: .system)
        bell.setImage(UIImage(systemName: "bell"), for: .normal)
        bell.tintColor = Theme.ink
        bell.backgroundColor = .white
        bell.layer.cornerRadius = 22
        addSoftShadow(to: bell)
        bell.widthAnchor.constraint(equalToConstant: 44).isActive = true
        bell.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let row = makeStack([greeting, UIView(), bell], axis: .horizontal, spacing: 12)
        row.alignment = .center
        return row
    }

    private func sectionTitle(_ title: String, action: String?) -> UIView {
        var views: [UIView] = [makeLabel(title, Theme.font(20, .bold)), UIView()]
        if let action {
            views.append(makeLabel(action, Theme.font(15, .semibold), Theme.brand))
        }
        return makeStack(views, axis: .horizontal, spacing: 8)
    }

    private func categories() -> UIView {
        let chips = [
            categoryChip("Road", "figure.run", selected: true),
            categoryChip("Trail", "mountain.2.fill", selected: false),
            categoryChip("Apparel", "tshirt.fill", selected: false),
            categoryChip("Gear", "headphones", selected: false),
        ]
        let row = makeStack(chips, axis: .horizontal, spacing: 10)
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.clipsToBounds = false
        row.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            row.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 44),
        ])
        return scroll
    }

    private func categoryChip(_ title: String, _ symbol: String, selected: Bool) -> UIView {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: symbol)
        config.imagePadding = 8
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        config.cornerStyle = .capsule
        config.baseBackgroundColor = selected ? Theme.brand : .white
        config.baseForegroundColor = selected ? .white : Theme.ink
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 18)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = Theme.font(15, .semibold)
            return attributes
        }
        let chip = UIButton(configuration: config)
        addSoftShadow(to: chip)
        return chip
    }

    private func productGrid() -> UIView {
        let rows = stride(from: 0, to: featured.count, by: 2).map { index in
            let row = makeStack([
                ProductCardView(featured[index]),
                ProductCardView(featured[index + 1]),
            ], axis: .horizontal, spacing: 14)
            row.distribution = .fillEqually
            row.alignment = .top
            return row
        }
        return makeStack(rows, axis: .vertical, spacing: 14)
    }
}

class HeroBannerView: UIView {
    private let shade = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 24
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 184).isActive = true

        let photo = UIImageView(image: UIImage(named: "Hero"))
        photo.contentMode = .scaleAspectFill
        photo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photo)

        shade.colors = [UIColor.black.withAlphaComponent(0.62).cgColor, UIColor.black.withAlphaComponent(0.05).cgColor]
        shade.startPoint = CGPoint(x: 0, y: 0.5)
        shade.endPoint = CGPoint(x: 0.85, y: 0.5)
        layer.addSublayer(shade)

        var config = UIButton.Configuration.filled()
        config.title = "Shop now"
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .white
        config.baseForegroundColor = Theme.ink
        config.contentInsets = NSDirectionalEdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = Theme.font(14, .bold)
            return attributes
        }
        let button = UIButton(configuration: config)

        let title = makeLabel("Summer run club", Theme.font(24, .heavy), .white)
        let subtitle = makeLabel("Up to 30% off road shoes", Theme.font(15, .medium), UIColor.white.withAlphaComponent(0.9))
        let text = makeStack([title, subtitle, button], axis: .vertical, spacing: 4)
        text.alignment = .leading
        text.setCustomSpacing(14, after: subtitle)
        text.translatesAutoresizingMaskIntoConstraints = false
        addSubview(text)

        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: topAnchor),
            photo.bottomAnchor.constraint(equalTo: bottomAnchor),
            photo.leadingAnchor.constraint(equalTo: leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: trailingAnchor),
            text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            text.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        shade.frame = bounds
    }
}
