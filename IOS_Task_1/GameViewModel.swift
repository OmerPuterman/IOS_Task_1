import SwiftUI
import Combine

enum AppState { case menu, playing, result }

struct Card {
    let imageName: String
    let strength: Int
    let color: Color
}

class GameViewModel: ObservableObject {
    @Published var currentState: AppState = .menu
    @AppStorage("savedUserName") var savedUserName: String = ""
    @Published var userName: String = ""
    
    @Published var userScore: Int = 0
    @Published var pcScore: Int = 0
    @Published var currentRound: Int = 0
    
    @Published var showCards: Bool = false
    @Published var userCard: Card?
    @Published var pcCard: Card?
    @Published var winnerName: String = ""
    
    private var timer: AnyCancellable?
    
    
        
    
    @Published var deck: [Card] = []
        
        init() {
            self.userName = savedUserName
            generateFullDeck()
        }
    
    func saveName() {
        savedUserName = userName
    }
    
    func startGame() {
        userScore = 0
        pcScore = 0
        currentRound = 0
        currentState = .playing
        startRound()
    }
    
    private func startRound() {
        if currentRound >= 10 {
            finishGame()
            return
        }
        
        currentRound += 1
        userCard = deck.randomElement()
        pcCard = deck.randomElement()
        showCards = true
        
        if let uCard = userCard, let pCard = pcCard {
            if uCard.strength > pCard.strength {
                userScore += 1
            } else if pCard.strength > uCard.strength {
                pcScore += 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showCards = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startRound()
        }
    }
    
    private func finishGame() {
        timer?.cancel()
        if userScore > pcScore {
            winnerName = userName
        } else {
            winnerName = "PC"
        }
        currentState = .result
    }
    
    func resetToMenu() {
        currentState = .menu
    }
    
    private func generateFullDeck() {
            let suits = ["suit.spade.fill", "suit.heart.fill", "suit.club.fill", "suit.diamond.fill"]
            var newDeck: [Card] = []
            
            for suit in suits {
           
                let cardColor: Color = (suit == "suit.heart.fill" || suit == "suit.diamond.fill") ? .red : .black
                
             
                for strength in 1...13 {
                    let newCard = Card(imageName: suit, strength: strength, color: cardColor)
                    newDeck.append(newCard)
                }
            }
            
            self.deck = newDeck
        }
    }

