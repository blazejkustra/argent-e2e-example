import UIKit

enum Theme {
    static let brand = UIColor(hex: 0x2E5CF2)
    static let ink = UIColor(hex: 0x111827)
    static let muted = UIColor(hex: 0x6B7280)
    static let canvas = UIColor(hex: 0xF5F6FA)
    static let star = UIColor(hex: 0xF5A524)

    static func font(_ size: CGFloat, _ weight: UIFont.Weight) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        guard let rounded = base.fontDescriptor.withDesign(.rounded) else { return base }
        return UIFont(descriptor: rounded, size: size)
    }
}

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

func makeLabel(_ text: String, _ font: UIFont, _ color: UIColor = Theme.ink) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = color
    return label
}

func makeStack(_ views: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: views)
    stack.axis = axis
    stack.spacing = spacing
    return stack
}

func addSoftShadow(to view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.06
    view.layer.shadowRadius = 12
    view.layer.shadowOffset = CGSize(width: 0, height: 4)
}

func pageScrollView(content: UIStackView, in view: UIView) -> UIScrollView {
    let scroll = UIScrollView()
    scroll.alwaysBounceVertical = true
    scroll.keyboardDismissMode = .onDrag
    scroll.translatesAutoresizingMaskIntoConstraints = false
    content.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scroll)
    scroll.addSubview(content)
    NSLayoutConstraint.activate([
        scroll.topAnchor.constraint(equalTo: view.topAnchor),
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 12),
        content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
        content.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
        content.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
    ])
    return scroll
}
