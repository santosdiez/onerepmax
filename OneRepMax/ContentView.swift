//
//  ContentView.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 16/3/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let exerciseStorage: ExerciseStorage
    
    var body: some View {
        NavigationView {
            ExercisesList(
                viewModel: ExercisesListViewModel(
                    model: ExercisesListModel(
                        exercisesStorage: exerciseStorage
                    )
                )
            )
        }
        .navigationViewStyle(.stack)
    }
}
