//
//  CardFlipperView.swift
//  CardFlipper
//
//  Created by handic on 19.11.2024.
//

import SwiftUI

struct CardFlipperView: View {
    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = []
    @State private var resultMessage: String = ""
    @State private var resultColor: Color = .black
    @State private var showResult: Bool = false
    @State private var isInteractionDisabled: Bool = false // Oyuncu girişini kilitlemek için
    
    private let cardColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if showResult {
                Text(resultMessage)
                    .font(.largeTitle)
                    .foregroundColor(resultColor)
                    .transition(.opacity)
                    .padding()
            }
            
            LazyVGrid(columns: cardColumns, spacing: 30) {
                ForEach(cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            if !isInteractionDisabled { // Sadece kilitli değilse tıklanabilir
                                if showResult {
                                    startNewGame()
                                } else {
                                    handleTap(on: card)
                                }
                            }
                        }
                }
            }
            .padding()
        }
        .onAppear(perform: startNewGame)
    }
    
    func handleTap(on card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isFlipped else { return }
        
        // Flip the card with rotation effect
        cards[index].isFlipped = true
        
        flippedCards.append(cards[index])
        
        if flippedCards.count == 2 {
            isInteractionDisabled = true // Tüm kartları kilitle
            checkGameResult()
        }
    }
    
    func checkGameResult() {
        let flippedStarCards = flippedCards.filter { $0.isStar }
        
        if flippedStarCards.count == 2 {
            resultMessage = "You Win!"
            resultColor = .green
            showResult = true
            isInteractionDisabled = false
        } else {
            startAgain()
        }
    }
    
    func startAgain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            // Reset flipped cards
            for card in flippedCards {
                if let index = cards.firstIndex(where: { $0.id == card.id }) {
                    cards[index].isFlipped = false
                }
            }
            flippedCards.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            cards.shuffle()
            isInteractionDisabled = false
        }
    }
    
    func startNewGame() {
        resultMessage = ""
        resultColor = .black
        showResult = false
        flippedCards = []
        isInteractionDisabled = false // Yeni oyun başlangıcında kartlar tıklanabilir
        
        let newCards = [
            Card(id: UUID(), isStar: true),
            Card(id: UUID(), isStar: true),
            Card(id: UUID(), isStar: false),
            Card(id: UUID(), isStar: false),
            Card(id: UUID(), isStar: false),
            Card(id: UUID(), isStar: false)
        ]
        
        cards = newCards.shuffled()
    }
}

#Preview {
    CardFlipperView()
}
