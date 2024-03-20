import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

struct ContentView: View {
    @State private var cards = [Card(content: "🐶"), Card(content: "🐱"), Card(content: "🐭"), Card(content: "🐹"),
                                 Card(content: "🦊"), Card(content: "🐻"), Card(content: "🐼"), Card(content: "🐨"),
                                 Card(content: "🐯"), Card(content: "🦁"), Card(content: "🐮"), Card(content: "🐷")]
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
            
            Button("New Game") {
                newGame()
            }
            .padding()
        }
    }
    
    func flipCard(_ card: Card) {
        if let index = cards.firstIndex(where: { $0.id == card.id }), !cards[index].isFaceUp, !cards[index].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[index].content == cards[potentialMatchIndex].content {
                    cards[index].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                indexOfTheOneAndOnlyFaceUpCard = index
            }
            cards[index].isFaceUp.toggle()
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
        ZStack {
            if card.isFaceUp || card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .aspectRatio(2/3, contentMode: .fit)
                Text(card.content)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
