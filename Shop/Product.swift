struct Product: Identifiable {
    let id: Int
    let name: String
    let price: String
}

let catalog = [
    Product(id: 1, name: "Trail running shoes", price: "$129"),
    Product(id: 2, name: "Road running shoes", price: "$119"),
    Product(id: 3, name: "Running shoes for kids", price: "$59"),
    Product(id: 4, name: "Running socks", price: "$15"),
    Product(id: 5, name: "Rain jacket", price: "$89"),
    Product(id: 6, name: "Water bottle", price: "$19"),
]

func search(_ query: String) -> [Product] {
    let words = query.lowercased().split(separator: " ")
    return catalog.filter { product in
        words.allSatisfy { product.name.lowercased().contains($0) }
    }
}
