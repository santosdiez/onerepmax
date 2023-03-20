//
//  ExercisesList.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation
import SwiftUI

struct ExercisesList<ViewModel: ExercisesListViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        listView
            .listStyle(.plain)
            .navigationBarTitle("sExerciseListTitle", displayMode: .inline)
    }
    
    @ViewBuilder
    var listView: some View {
        List {
            if viewModel.exercises.isEmpty {
                emptyListView
            } else {
                exercisesListView
            }
        }
    }
    
    var emptyListView: some View {
        Text("sEmptyList")
            .font(.headline)
            .padding(.vertical)
    }

    var exercisesListView: some View {
        ForEach(viewModel.exercises) { exercise in
            ZStack {
                NavigationLink(destination: ExerciseDetail(
                    viewModel: ExerciseDetailViewModel(
                        model: ExerciseDetailModel(exerciseId: exercise.id)
                    )
                )) {
                    EmptyView()
                }.opacity(0.0)
                ExerciseRow(exercise: exercise)
            }
            .listRowInsets(EdgeInsets())
        }
    }
}

struct ExerciseRow: View {
    let exercise: ExercisesListItem
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(exercise.name)
                    .font(.title3.bold())
                Text("sExerciseRowSubtitle")
                    .font(.caption2)
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            VStack(alignment: .trailing) {
                if let oneRepMax = exercise.oneRepMax?.formatted() {
                    Text(oneRepMax)
                        .font(.title2)
                } else {
                    Text("sNotAvailable")
                }
            }
        }
        .padding()
    }
}

// MARK: - Previews

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExercisesList(
                viewModel: ExercisesListViewModel(
                    model: ExercisesListModel(exercisesStorage: StorageManager.exerciseStoragePreview)
                )
            )
            .environment(\.locale, .init(identifier: "en"))
            .preferredColorScheme(.dark)
            
            ExercisesList(
                viewModel: ExercisesListViewModel(
                    model: ExercisesListModel(exercisesStorage: StorageManager.exerciseStoragePreview)
                )
            )
            .environment(\.locale, .init(identifier: "es"))
            .preferredColorScheme(.dark)
        }
    }
}
