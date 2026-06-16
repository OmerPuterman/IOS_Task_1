import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    var backgroundPlayer: AVAudioPlayer?
    var effectPlayer: AVAudioPlayer?
        
    init() {
        print("⏳ SoundManager: Starting AudioSession setup...")
        do {
            // הגדרה שמאפשרת ניגון שמע גם כשהטלפון במצב שקט
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ SoundManager: AudioSession setup complete!")
        } catch {
            print("❌ Failed to set audio session category. Error: \(error)")
        }
    }
    
    // הפעלת מוזיקת הרקע בלולאה (Loop)
    func playBackgroundMusic() {
        print("⏳ SoundManager: Attempting to load bg_music...")
        guard let url = Bundle.main.url(forResource: "bg_music", withExtension: "mp3") else {
            print("❌ Could not find bg_music.mp3 in the bundle")
            return
        }
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.play()
            print("✅ SoundManager: Background music is playing!")
        } catch {
            print("❌ Error playing background music")
        }
    }
    
    // השהיית מוזיקת הרקע
    func pauseBackgroundMusic() {
        backgroundPlayer?.pause()
    }
    
    // המשך ניגון מוזיקת הרקע
    func resumeBackgroundMusic() {
        backgroundPlayer?.play()
    }
    
    // ניגון אפקט קצר (היפוך קלף או ניצחון)
    func playEffect(soundName: String, extensionName: String = "mp3") {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: extensionName) else {
            print("❌ Could not find \(soundName).\(extensionName) in the bundle")
            return
        }
        do {
            effectPlayer = try AVAudioPlayer(contentsOf: url)
            effectPlayer?.play()
        } catch {
            print("❌ Error playing sound effect: \(soundName)")
        }
    }
}
