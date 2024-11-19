//
//  Card.swift
//  CardFlipper
//
//  Created by handic on 19.11.2024.
//

import Foundation

struct Card: Identifiable {
    let id: UUID
    var isStar: Bool
    var isFlipped: Bool = false
}
