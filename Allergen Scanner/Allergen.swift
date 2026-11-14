//
//  Allergen.swift
//  Allergen Scanner
//
//  Created by Brandon Yeung on 2025-06-14.
//

import Foundation

//defining the structure of how the allergens and their aliases are stored
struct Allergen: Identifiable, Codable, Hashable {
    var id: String { name } 
    let name: String
    let keywords: [String]

    init(name: String, keywords: [String]) {
        self.name = name
        self.keywords = keywords
    }
}


// Static list of known allergens (alphabetically sorted)
let knownAllergens: [Allergen] = [
    Allergen(name: "Banana", keywords: ["banana"]),
    Allergen(name: "Buckwheat", keywords: ["buckwheat"]),
    Allergen(name: "Celery", keywords: ["celery", "celeriac"]),
    Allergen(name: "Corn", keywords: ["corn", "maize", "corn starch"]),
    Allergen(name: "Eggs", keywords: ["egg", "albumin", "lysozyme", "ovomucoid"]),
    Allergen(name: "Fish", keywords: ["fish", "anchovy", "cod", "salmon"]),
    Allergen(name: "Gluten", keywords: ["gluten", "barley", "rye"]),
    Allergen(name: "Lupin", keywords: ["lupin", "lupine flour"]),
    Allergen(name: "Mango", keywords: ["mango"]),
    Allergen(name: "Milk", keywords: ["milk", "casein", "whey", "lactoglobulin"]),
    Allergen(name: "Mustard", keywords: ["mustard", "mustard flour"]),
    Allergen(name: "Peach", keywords: ["peach"]),
    Allergen(name: "Peanuts", keywords: ["peanut", "arachis oil", "ground nut", "goober nut"]),
    Allergen(name: "Pork", keywords: ["pork"]),
    Allergen(name: "Sesame", keywords: ["sesame", "sesame oil", "tahini"]),
    Allergen(name: "Shellfish", keywords: ["shellfish", "shrimp", "crab", "lobster"]),
    Allergen(name: "Soy", keywords: ["soy", "soy lecithin", "textured vegetable protein"]),
    Allergen(name: "Sulfites", keywords: ["sulfites", "sulfur dioxide"]),
    Allergen(name: "Tree Nuts", keywords: ["tree nut", "almond", "cashew", "hazelnut", "macadamia", "pecans", "pine nuts", "pistachio", "walnut"]),
    Allergen(name: "Wheat", keywords: ["wheat", "durum", "semolina", "spelt"]),
]

