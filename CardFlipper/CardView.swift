//
//  CardView.swift
//  CardFlipper
//
//  Created by handic on 19.11.2024.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            if card.isFlipped {
                Rectangle()
                    .fill(card.isStar ? Color.yellow : Color.gray)
                    .cornerRadius(10)
                    .overlay(
                        card.isStar ? Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.orange)
                            .padding(20) : nil
                    )
            } else {
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(10)
            }
        }
        .frame(width: 150, height: 200)
        .rotation3DEffect(
            .degrees(card.isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.easeInOut(duration: 0.4), value: card.isFlipped)
        .shadow(radius: 3)
    }
}
