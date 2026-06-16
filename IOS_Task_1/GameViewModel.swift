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
    
    @Published var deck: [Card] = []
    
    // משתני טיימר לניהול ה-Lifecycle
    private var gameTimer: Timer?
    private var secondsInCurrentRound = 0
    private var isGameActive = false
    
    init() {
        self.userName = savedUserName
        generateFullDeck()
    }
    
    func saveName() {
        savedUserName = userName
    }
    
    private func generateFullDeck() {
        let suits = ["suit.spade.fill", "suit.heart.fill", "suit.club.fill", "suit.diamond.fill"]
        var newDeck: [Card] = []
        for suit in suits {
            let cardColor: Color = (suit == "suit.heart.fill" || suit == "suit.diamond.fill") ? .red : .primary
            for strength in 2...14 {
                newDeck.append(Card(imageName: suit, strength: strength, color: cardColor))
            }
        }
        self.deck = newDeck
    }
    
    /// מתחיל את המשחק ומאפס נתונים.
    func startGame() {
        userScore = 0
        pcScore = 0
        currentRound = 0
        currentState = .playing
        SoundManager.shared.playBackgroundMusic()
        startNewRound()
    }
    
    /// מתחיל משחקון חדש ושולף קלפים.
    private func startNewRound() {
        if currentRound >= 10 {
            finishGame()
            return
        }
        currentRound += 1
        secondsInCurrentRound = 0
        userCard = deck.randomElement()
        pcCard = deck.randomElement()
        showCards = false // מתחיל מוסתר
        
        isGameActive = true
        startTimer()
    }
    
    /// הפעלת השעון לניהול המחזוריות (5 שניות לכל סיבוב)
    private func startTimer() {
        gameTimer?.invalidate() // מניעת כפילויות של טיימרים
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.handleTimerTick()
        }
    }
    
    /// פונקציה זו מנהלת את ההיגיון של כל שנייה במשחקון.
    private func handleTimerTick() {
        secondsInCurrentRound += 1
        
        if secondsInCurrentRound == 1 {
            // חשיפת הקלפים אחרי שנייה אחת
            showCards = true
           SoundManager.shared.playEffect(soundName: "flip")
            calculateScore()
        } else if secondsInCurrentRound == 4 {
            // הסתרת הקלפים אחרי 3 שניות של תצוגה
            showCards = false
        } else if secondsInCurrentRound >= 5 {
            // מעבר לסיבוב הבא
            gameTimer?.invalidate()
            startNewRound()
        }
    }
    
    private func calculateScore() {
        if let uCard = userCard, let pCard = pcCard {
            if uCard.strength > pCard.strength { userScore += 1 }
            else if pCard.strength > uCard.strength { pcScore += 1 }
            // במקרה של שוויון מתעלמים
        }
    }
    
    /// פונקציה לבקרה על מחזור חיי האפליקציה - השהיית משחק
    func pauseGame() {
        guard isGameActive else { return }
        gameTimer?.invalidate()
       SoundManager.shared.pauseBackgroundMusic()
    }
    
    /// פונקציה לבקרה על מחזור חיי האפליקציה - חזרה למשחק
    func resumeGame() {
        guard isGameActive else { return }
        SoundManager.shared.resumeBackgroundMusic()
        startTimer() // חידוש הטיימר מהנקודה שבה עצר
    }
    
    /// סיום המשחק והכרזת המנצח
    private func finishGame() {
        isGameActive = false
        gameTimer?.invalidate()
        SoundManager.shared.pauseBackgroundMusic()
        SoundManager.shared.playEffect(soundName: "win")
        
        // במקרה של תיקו הבית מנצח
        winnerName = userScore > pcScore ? userName : "PC"
        currentState = .result
    }
    
    func resetToMenu() {
        currentState = .menu
    }
}
