import UIKit

struct Product {
    let name: String
    let detail: String
    let price: String
    let rating: String
    let symbol: String
    let tint: UIColor
    let backdrop: UIColor
}

let catalog = [
    Product(name: "Trail running shoes", detail: "Grippy lugs, waterproof", price: "$129", rating: "4.8",
            symbol: "shoe.fill", tint: UIColor(hex: 0x1F7A5C), backdrop: UIColor(hex: 0xE3F3EC)),
    Product(name: "Road running shoes", detail: "Lightweight, 8 mm drop", price: "$119", rating: "4.7",
            symbol: "shoe.fill", tint: Theme.brand, backdrop: UIColor(hex: 0xE7EDFF)),
    Product(name: "Running shoes for kids", detail: "Hook and loop, sizes 28 to 35", price: "$59", rating: "4.9",
            symbol: "shoe.2.fill", tint: UIColor(hex: 0xDB2777), backdrop: UIColor(hex: 0xFDE8F1)),
    Product(name: "Sport headphones", detail: "Sweatproof, 30 h battery", price: "$79", rating: "4.6",
            symbol: "headphones", tint: Theme.ink, backdrop: UIColor(hex: 0xEDEFF3)),
    Product(name: "Insulated bottle", detail: "Keeps cold for 24 h", price: "$24", rating: "4.8",
            symbol: "waterbottle.fill", tint: UIColor(hex: 0x0369A1), backdrop: UIColor(hex: 0xE2F1FB)),
    Product(name: "Running shirt", detail: "Breathable mesh", price: "$35", rating: "4.5",
            symbol: "tshirt.fill", tint: UIColor(hex: 0x7C3AED), backdrop: UIColor(hex: 0xF0E9FE)),
    Product(name: "GPS stopwatch", detail: "Pace, splits and laps", price: "$149", rating: "4.4",
            symbol: "stopwatch.fill", tint: UIColor(hex: 0x4338CA), backdrop: UIColor(hex: 0xE8E7FB)),
]

func search(_ query: String) -> [Product] {
    let words = query.lowercased().split(separator: " ")
    return catalog.filter { product in
        words.allSatisfy { product.name.lowercased().contains($0) }
    }
}
