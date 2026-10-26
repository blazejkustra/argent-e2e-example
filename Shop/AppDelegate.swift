import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.tintColor = Theme.brand
        window.rootViewController = ShopTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

class ShopTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        let bag = EmptyStateViewController(title: "Bag", symbol: "bag", message: "Your bag is empty")
        bag.tabBarItem.badgeValue = "2"
        viewControllers = [
            tab(HomeViewController(), "Home", "house", id: "home-tab"),
            tab(SearchViewController(), "Search", "magnifyingglass", id: "search-tab"),
            tab(bag, "Bag", "bag", id: "bag-tab"),
            tab(EmptyStateViewController(title: "Profile", symbol: "person", message: "Sign in to see your orders"), "Profile", "person", id: "profile-tab"),
        ]
    }

    private func tab(_ controller: UIViewController, _ title: String, _ symbol: String, id: String) -> UIViewController {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: symbol)
        controller.tabBarItem.selectedImage = UIImage(systemName: "\(symbol).fill") ?? UIImage(systemName: symbol)
        controller.tabBarItem.accessibilityIdentifier = id
        return controller
    }
}

class EmptyStateViewController: UIViewController {
    private let symbol: String
    private let message: String

    init(title: String, symbol: String, message: String) {
        self.symbol = symbol
        self.message = message
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.canvas
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.tintColor = Theme.muted
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        let stack = makeStack([icon, makeLabel(message, Theme.font(17, .semibold), Theme.muted)], axis: .vertical, spacing: 12)
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
