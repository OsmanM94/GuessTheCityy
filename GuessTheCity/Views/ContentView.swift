
import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @State private var viewModel = GameViewModel()
    @State private var audioManager = AudioManager()
    @Environment(AchievementViewModel.self) private var achievementViewModel
   
    @Environment(\.modelContext) private var modelContext
    @Query private var statistics: [Statistics]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(decorative: "castle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .containerRelativeFrame([.vertical,.horizontal])
                
                VStack {
                    switch viewModel.gameState {
                    case .loading:
                        Spacer()
                        ProgressView("Loading locations...")
                        Spacer()
                    case .playing:
                        gameContent
                    case .error(let message):
                        errorView(message)
                    }
                }
                
                AchievementView()
                    .animation(.easeInOut, value: achievementViewModel.showingAchievement)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .fontDesign(.rounded)
            .alert(isPresented: $viewModel.showingFeedback) {
                Alert(title: Text(viewModel.feedbackMessage), dismissButton: .default(Text("Next").foregroundStyle(.white)) {
                    updateStatistics(correct: viewModel.isLastGuessCorrect)
                    achievementViewModel.updateAchievements(correct: viewModel.isLastGuessCorrect)
                    viewModel.nextRound()
                })
            }
            .toolbar {
                toolbarContent
            }
        }
    }
    
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            
            Text(message)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            
            Button {
                Task {
                    await viewModel.loadLocations()
                }
            } label: {
                Text("Retry")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var gameContent: some View {
        if let currentLocation = viewModel.currentLocation {
            ScrollView {
                VStack(alignment: .center, spacing: 15) {
                    Text("\(currentLocation.hint)")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityLabel("Hint for the location: \(currentLocation.hint)")
                        .popoverTip(LocationNameTip())
                    
                    Image(decorative: "paper")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(height: 350)
                        .padding(10)
                        .shadow(color: .black, radius: 5)
                        .overlay {
                            Text(currentLocation.info)
                                .foregroundStyle(.black)
                                .font(.headline)
                                .padding()
                                .padding()
                        }
                        .accessibilityLabel("Information about the location: \(currentLocation.info)")
                    
                    mapView
                    
                    TextField("",text: $viewModel.userGuess, prompt: Text("Enter your guess").foregroundStyle(.white))
                        .customTextField()
                        .autocorrectionDisabled()
                        .autocapitalization(.words)
                        .onSubmit {
                            guard !viewModel.userGuess.isEmpty else { return }
                            viewModel.submitGuess()
                        }
                        .submitLabel(.done)
                        .accessibilityLabel("Enter your guess for the location")
                    
                    HStack {
                        Text("Score: \(viewModel.score)")
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityLabel("Current score: \(viewModel.score)")
                        
                        Button(action: {
                            viewModel.startNewGame()
                        }, label: {
                            Text("Skip")
                                .fontWeight(.semibold)
                        })
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                        .sensoryFeedback(.impact, trigger: viewModel.triggerFeedback)
                        .accessibilityLabel("Skip this location")
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }
    
    private var mapView: some View {
        DisclosureGroup {
            Map(position: $viewModel.cameraPosition) {
                if let currentLocation = viewModel.currentLocation,
                   let span = viewModel.currentSpan {
                    MapCircle(center: currentLocation.coordinate, radius: span.latitudeDelta * 25500)
                        .foregroundStyle(.blue.opacity(0.2))
                        .stroke(.blue, lineWidth: 2)
                }
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        } label: {
            Label("Map", systemImage: "map.fill")
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityLabel("Expandable map view showing the general area of the location")
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button(action: audioManager.toggleMusic) {
                    Image(systemName: audioManager.isMusicPlaying ? "speaker.wave.3.fill" : "speaker.slash.fill")
                }
                .accessibilityLabel(audioManager.isMusicPlaying ? "Pause background music" : "Play background music")
                
                Menu {
                    ForEach(audioManager.musicTracks, id: \.self) { track in
                        Button(action: {
                            audioManager.selectedTrack = track
                        }, label: {
                            HStack {
                                Text(track)
                                if track == audioManager.selectedTrack {
                                    Image(systemName: "checkmark")
                                }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "music.note.list")
                }
                .accessibilityLabel("Select background music track")
            }
            .padding(5)
            .background(Color.black.opacity(0.8))
            .clipShape(Capsule())
        }
    }
    
    private func updateStatistics(correct: Bool) {
        if let stats = statistics.first {
            stats.totalQuestionsAnswered += 1
            if correct {
                stats.totalCorrect += 1
                stats.currentStreak += 1
                stats.longestStreak = max(stats.longestStreak, stats.currentStreak)
            } else {
                stats.currentStreak = 0
            }
            stats.highestScore = max(stats.highestScore, viewModel.score)
            try? modelContext.save()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
            .environment(AchievementViewModel())
    }
}

