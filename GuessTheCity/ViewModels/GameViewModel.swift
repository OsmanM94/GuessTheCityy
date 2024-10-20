
import SwiftUI
import MapKit

@Observable
final class GameViewModel {
    
    enum GameState {
        case loading
        case playing
        case error(String)
    }
    
    // MARK: - Properties
    
    private(set) var locations: [UKLocation] = []
    private(set) var currentLocation: UKLocation?
    private(set) var currentSpan: MKCoordinateSpan?
    
    private(set) var score: Int = 0
    var gameState: GameState = .loading
    var userGuess: String = ""
    var showingFeedback: Bool = false
    var triggerFeedback: Bool = false
    var feedbackMessage: String = ""
    var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.5, longitude: -4),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    ))
    
    // New property for statistics
    private(set) var isLastGuessCorrect: Bool = false
    
    // MARK: - Initialization
    
    init() {
        Task {
            await loadLocations()
        }
    }
    
    // MARK: - Game Logic
    
    @MainActor
    func loadLocations() async {
        do {
            guard let url = Bundle.main.url(forResource: "uk_locations", withExtension: "json") else {
                gameState = .error("Failed to load game data")
                return
            }
            
            let data = try Data(contentsOf: url)
            locations = try JSONDecoder().decode([UKLocation].self, from: data)
            gameState = .playing
            
            startNewGame()
        } catch {
            print("Error loading or decoding UK locations: \(error)")
            gameState = .error("Failed to load game data")
        }
    }
    
    func startNewGame() {
        self.triggerFeedback.toggle()
        nextRound()
    }
    
    func nextRound() {
        userGuess = ""
        currentLocation = locations.randomElement()
        updateMapRegion()
    }
    
    func submitGuess() {
        guard let currentLocation = currentLocation else { return }
        
        isLastGuessCorrect = userGuess.lowercased() == currentLocation.name.lowercased()
        
        if isLastGuessCorrect {
            score += 1
            feedbackMessage = "Correct! It was \(currentLocation.name)."
        } else {
            feedbackMessage = "Sorry, the correct answer was \(currentLocation.name)."
        }
        showingFeedback = true
    }
    
    func updateMapRegion() {
        guard let currentLocation = currentLocation else { return }
        let span = MKCoordinateSpan(
            latitudeDelta: currentLocation.hintRadius / 54.5,
            longitudeDelta: currentLocation.hintRadius / 54.5
        )
        currentSpan = span
        cameraPosition = .region(MKCoordinateRegion(center: currentLocation.coordinate, span: span))
    }
}
