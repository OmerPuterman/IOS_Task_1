import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var locationManager = LocationManager()
    
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
    }
}

struct MenuView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 50) {
            if viewModel.savedUserName.isEmpty {
                TextField("Insert name", text: $viewModel.userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    .onChange(of: viewModel.userName) { _ in
                        viewModel.saveName()
                    }
            } else {
                Text("Hi \(viewModel.userName)")
                    .font(.largeTitle).bold()
            }
            
            HStack {
                VStack {
                    Image(systemName: "globe.americas.fill")
                        .resizable().scaledToFit().frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    Text("West Side")
                }
                Spacer()
                VStack {
                    Image(systemName: "globe.asia.australia.fill")
                        .resizable().scaledToFit().frame(width: 60, height: 60)
                        .foregroundColor(.green)
                    Text("East Side")
                }
            }
            .padding(.horizontal, 40)
            
            if locationManager.locationReady && !viewModel.userName.isEmpty {
                Text("You are on the: \(locationManager.userSide ?? "")")
                    .foregroundColor(.gray)
                
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
    }
}

struct ActiveGameView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Round \(viewModel.currentRound) / 10")
                .font(.headline).foregroundColor(.gray)
            
            HStack(spacing: 40) {
                VStack(spacing: 15) {
                    Text(viewModel.userName).font(.title2).bold()
                    Text("Score: \(viewModel.userScore)")
                    if viewModel.showCards, let card = viewModel.userCard {
                        PlayingCardView(iconName: card.imageName, strength: card.strength, iconColor: card.color)
                    } else { CardBackView() }
                }
                
                VStack(spacing: 15) {
                    Text("PC").font(.title2).bold()
                    Text("Score: \(viewModel.pcScore)")
                    if viewModel.showCards, let card = viewModel.pcCard {
                        PlayingCardView(iconName: card.imageName, strength: card.strength, iconColor: card.color)                    } else { CardBackView() }
                }
            }
        }
    }
}

struct ResultSummaryView: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        VStack(spacing: 30) {
            Text("Winner: \(viewModel.winnerName)").font(.largeTitle).bold()
            Text("Score: \(viewModel.winnerName == viewModel.userName ? viewModel.userScore : viewModel.pcScore)").font(.title)
            
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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            VStack(spacing: 15) {
                Image(systemName: iconName).resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(iconColor)
                Text("\(strength)").font(.title).bold()
            }
        }
        .frame(width: 100, height: 150)
    }
}

struct CardBackView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2))
            .frame(width: 100, height: 150)
            .overlay(Image(systemName: "questionmark.circle.fill").foregroundColor(.gray))
    }
}
