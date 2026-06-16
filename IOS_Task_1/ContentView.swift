import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var locationManager = LocationManager()
    
    // מעקב אחרי מחזור חיי האפליקציה
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Group {
            switch viewModel.currentState {
            case .menu:
                MenuView(viewModel: viewModel, locationManager: locationManager)
            case .playing:
                ActiveGameView(viewModel: viewModel, locationManager: locationManager)
            case .result:
                ResultSummaryView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut, value: viewModel.currentState)
        // האזנה ליציאה וחזרה לאפליקציה
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                viewModel.resumeGame()
            } else if newPhase == .background || newPhase == .inactive {
                viewModel.pauseGame()
            }
        }
    }
}

struct MenuView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var locationManager: LocationManager
    @Environment(\.colorScheme) var colorScheme // זיהוי מצב לילה
    
    var body: some View {
        // שימוש ב-ScrollView כדי לתמוך במצב אופקי (Landscape)
        ScrollView {
            VStack(spacing: 50) {
                if viewModel.savedUserName.isEmpty {
                    TextField("Insert name", text: $viewModel.userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 40)
                        .onChange(of: viewModel.userName) { _, _ in viewModel.saveName() }
                } else {
                    Text("Hi \(viewModel.userName)")
                        .font(.largeTitle).bold()
                        .foregroundColor(.primary) // הופך לבהיר במצב לילה
                }
                
                HStack {
                    VStack {
                        Image(systemName: "globe.americas.fill")
                            .resizable().scaledToFit().frame(width: 60, height: 60)
                            // משנה צבעים מעט במצב לילה להרגשה מתאימה
                            .foregroundColor(colorScheme == .dark ? .cyan : .blue)
                        Text("West Side").foregroundColor(.primary)
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "globe.asia.australia.fill")
                            .resizable().scaledToFit().frame(width: 60, height: 60)
                            .foregroundColor(colorScheme == .dark ? .mint : .green)
                        Text("East Side").foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 40)
                
                if locationManager.locationReady && !viewModel.userName.isEmpty {
                    Button(action: { viewModel.startGame() }) {
                        Text("START")
                            .bold().foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue).cornerRadius(10)
                    }
                } else {
                    Text("Waiting for setup...").foregroundColor(.gray)
                }
            }
            .padding(.top, 50)
        }
    }
}

struct ActiveGameView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                Text("Round \(viewModel.currentRound) / 10")
                    .font(.headline).foregroundColor(.gray)
                
                HStack(spacing: 40) {
                    VStack(spacing: 15) {
                        Text(viewModel.userName).font(.title2).bold().foregroundColor(.primary)
                        Text("Score: \(viewModel.userScore)").foregroundColor(.primary)
                        if viewModel.showCards, let card = viewModel.userCard {
                            PlayingCardView(iconName: card.imageName, strength: card.strength, iconColor: card.color)
                        } else { CardBackView() }
                    }
                    
                    VStack(spacing: 15) {
                        Text("PC").font(.title2).bold().foregroundColor(.primary)
                        Text("Score: \(viewModel.pcScore)").foregroundColor(.primary)
                        if viewModel.showCards, let card = viewModel.pcCard {
                            PlayingCardView(iconName: card.imageName, strength: card.strength, iconColor: card.color)
                        } else { CardBackView() }
                    }
                }
            }
            .padding(.top, 40)
        }
    }
}

struct ResultSummaryView: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        VStack(spacing: 30) {
            Text("Winner: \(viewModel.winnerName)").font(.largeTitle).bold().foregroundColor(.primary)
            Text("score: \(viewModel.winnerName == viewModel.userName ? viewModel.userScore : viewModel.pcScore)")
                .font(.title).foregroundColor(.primary)
            
            Button(action: { viewModel.resetToMenu() }) {
                Text("BACK TO MENU")
                    .bold().foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue).cornerRadius(10)
            }
        }
    }
}

struct PlayingCardView: View {
    let iconName: String; let strength: Int; let iconColor: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color(white: 0.2) : Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            VStack(spacing: 15) {
                Image(systemName: iconName).resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(iconColor)
                Text(strength == 11 ? "J" : strength == 12 ? "Q" : strength == 13 ? "K" : strength == 14 ? "A" : "\(strength)")
                    .font(.title).bold().foregroundColor(.primary)
            }
        }
        .frame(width: 100, height: 150)
    }
}

struct CardBackView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(colorScheme == .dark ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
            .frame(width: 100, height: 150)
            .overlay(Image(systemName: "questionmark.circle.fill").foregroundColor(.gray))
    }
}
