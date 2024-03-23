import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

struct ContentView: View {
    @State private var cards = [Card(content: "🚀"), // Rocket
                                Card(content: "🚀"), // Rocket
                                Card(content: "👾"), // Alien Monster
                                Card(content: "👾"), // Alien Monster
                                Card(content: "💻"), // Laptop
                                Card(content: "💻"), // Laptop
                                Card(content: "📱"), // Mobile Phone
                                Card(content: "📱"), // Mobile Phone
                                Card(content: "⌚"), // Watch
                                Card(content: "⌚"), // Watch
                                Card(content: "🎮"), // Video Game
                                Card(content: "🎮"), ]// Video Game
    @State private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    @State private var numberOfPairs = 6 // Default number of pairs
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(cards.prefix(numberOfPairs * 2), content: { card in
                        CardView(card: card)
                            .onTapGesture {
                                flipCard(card)
                            }
                            .padding(4)
                    })
                }
            }
            Spacer()
            Picker("Number of Pairs", selection: $numberOfPairs) {
                ForEach(2..<7) { number in
                    Text("\(number) pairs").tag(number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: numberOfPairs) { _ in
                newGame()
            }

            
            Button("New Game") {
                newGame()
            }
            .padding()
        }
        .onAppear {
            newGame()
        }
    }
    
    func flipCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }), !cards[index].isFaceUp, !cards[index].isMatched else { return }
        
        cards[index].isFaceUp = true
        
        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[index].content == cards[potentialMatchIndex].content {
                // Match found
                cards[index].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            } else {
                // No match, schedule both cards to flip back down after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.cards[index].isFaceUp = false
                    self.cards[potentialMatchIndex].isFaceUp = false
                }
            }
            // Reset the index since we've now considered the second card
            self.indexOfTheOneAndOnlyFaceUpCard = nil
        } else {
            // First card flipped, close all others
            for flipDownIndex in cards.indices where flipDownIndex != index {
                cards[flipDownIndex].isFaceUp = false
            }
            // Mark this card as the only one face up
            indexOfTheOneAndOnlyFaceUpCard = index
        }
    }

    
    func newGame() {
        cards.shuffle()
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        Group {
            if card.isFaceUp || card.isMatched {
                if card.isMatched {
                    // Render a transparent rectangle for matched cards
                    RoundedRectangle(cornerRadius: 10)
                        .opacity(0)
                } else {
                    // Card is face up and not matched
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .aspectRatio(2/3, contentMode: .fit)
                        Text(card.content)
                            .font(.largeTitle)
                    }
                }
            } else {
                // Card is face down
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .aspectRatio(2/3, contentMode: .fit) // Ensures all cards have the same size, regardless of their state
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
