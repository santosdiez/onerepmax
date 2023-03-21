//
//  OneRepMaxApp.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 16/3/23.
//

import SwiftUI
import CoreData

@main
struct OneRepMaxApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(exerciseStorage: StorageManager.exerciseStorage)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    private lazy var exerciseImporters: [String: ExerciseImporter] = [
        "txt": PlainTextExerciseImporter(exerciseStorage: StorageManager.exerciseStorage)
    ]

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // The app is registered to handle plain text files, so that we can easily import new workout data
        guard let url = URLContexts.first?.url else {
            return
        }

        if let importer = exerciseImporters[url.pathExtension] {
            importer.importExercises(from: url)
        }
    }
}
