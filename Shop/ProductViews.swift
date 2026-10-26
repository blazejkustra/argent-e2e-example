import UIKit

class ProductTileView: UIView {
    private let floorShadow = CAShapeLayer()
    private let image = UIImageView()
    private let product: Product
    private var renderedPointSize: CGFloat = 0

    init(_ product: Product, cornerRadius: CGFloat) {
        self.product = product
        super.init(frame: .zero)
        backgroundColor = product.backdrop
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        floorShadow.fillColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.addSublayer(floorShadow)

        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        let pointSize = (bounds.height * 0.34).rounded()
        if pointSize != renderedPointSize {
            renderedPointSize = pointSize
            image.image = UIImage(systemName: product.symbol, withConfiguration: symbolConfiguration(pointSize))
        }
        let width = bounds.width * 0.5
        let rect = CGRect(x: (bounds.width - width) / 2, y: bounds.height * 0.8, width: width, height: bounds.height * 0.07)
        floorShadow.path = UIBezierPath(ovalIn: rect).cgPath
    }

    private func symbolConfiguration(_ pointSize: CGFloat) -> UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(pointSize: pointSize, weight: .regular)
            .applying(UIImage.SymbolConfiguration(hierarchicalColor: product.tint))
    }
}

class ProductCardView: UIView {
    init(_ product: Product) {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        addSoftShadow(to: self)

        let tile = ProductTileView(product, cornerRadius: 14)
        tile.heightAnchor.constraint(equalTo: tile.widthAnchor, multiplier: 0.9).isActive = true

        let name = makeLabel(product.name, Theme.font(15, .semibold))
        name.numberOfLines = 2
        let detail = makeLabel(product.detail, Theme.font(12, .regular), Theme.muted)
        let footer = makeStack([
            makeLabel(product.price, Theme.font(17, .bold)),
            UIView(),
            ratingView(product.rating),
        ], axis: .horizontal, spacing: 4)

        let stack = makeStack([tile, name, detail, footer], axis: .vertical, spacing: 6)
        stack.setCustomSpacing(10, after: tile)
        stack.setCustomSpacing(10, after: detail)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}

class ResultRowView: UIView {
    init(_ product: Product) {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        addSoftShadow(to: self)

        let tile = ProductTileView(product, cornerRadius: 14)
        tile.widthAnchor.constraint(equalToConstant: 92).isActive = true
        tile.heightAnchor.constraint(equalToConstant: 92).isActive = true

        let name = makeLabel(product.name, Theme.font(16, .semibold))
        let detail = makeLabel(product.detail, Theme.font(13, .regular), Theme.muted)
        let footer = makeStack([
            makeLabel(product.price, Theme.font(17, .bold)),
            ratingView(product.rating),
            UIView(),
        ], axis: .horizontal, spacing: 10)
        let text = makeStack([name, detail, footer], axis: .vertical, spacing: 4)
        text.setCustomSpacing(10, after: detail)

        let add = UIButton(type: .system)
        add.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
        add.tintColor = .white
        add.backgroundColor = Theme.brand
        add.layer.cornerRadius = 17
        add.widthAnchor.constraint(equalToConstant: 34).isActive = true
        add.heightAnchor.constraint(equalToConstant: 34).isActive = true

        let row = makeStack([tile, text, add], axis: .horizontal, spacing: 14)
        row.alignment = .center
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
}

func ratingView(_ rating: String) -> UIStackView {
    let star = UIImageView(image: UIImage(systemName: "star.fill"))
    star.tintColor = Theme.star
    star.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 11, weight: .bold)
    let stack = makeStack([star, makeLabel(rating, Theme.font(13, .semibold), Theme.muted)], axis: .horizontal, spacing: 3)
    stack.alignment = .center
    return stack
}
