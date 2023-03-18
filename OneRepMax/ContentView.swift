//
//  ContentView.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 16/3/23.
//

import SwiftUI
import CoreData

struct ContentView<Storage>: View where Storage: ExerciseStorage {
    @EnvironmentObject var exerciseStorage: Storage
    
    var body: some View {
        NavigationView {
            ExercisesList(
                viewModel: ExercisesListViewModel(
                    model: ExerciseListModel(
                        exercisesStorage: exerciseStorage
                    )
                )
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView<CoreDataExerciseStorage>()
                .environmentObject(CoreDataExerciseStorage.preview)
                .environment(\.locale, .init(identifier: "en"))
                .preferredColorScheme(.dark)
            ContentView<CoreDataExerciseStorage>()
                .environmentObject(CoreDataExerciseStorage.preview)
                .environment(\.locale, .init(identifier: "es"))
                .preferredColorScheme(.dark)
        }
    }
}
