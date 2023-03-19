//
//  ExercisesListView.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation
import SwiftUI

struct ExercisesList<ViewModel>: View where ViewModel: ExercisesListViewModelProtocol {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        listView
            .listStyle(PlainListStyle())
            .navigationTitle("sExerciseListTitle")
    }
    
    @ViewBuilder
    var listView: some View {
        if viewModel.exercises.isEmpty {
            emptyListView
        } else {
            objectsListView
        }
    }
    
    var emptyListView: some View {
        List {
            Text("sEmptyList")
                .font(.headline)
                .padding(.vertical)
        }
    }

    var objectsListView: some View {
        List {
            ForEach(viewModel.exercises) { exercise in
                ZStack {
                    NavigationLink(destination: EmptyView()) {
                        EmptyView()
                    }.opacity(0.0)
                    ExerciseRow(exercise: exercise)
                }
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: ExerciseListItem
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                Text(exercise.name)
                    .font(.headline)
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
        .padding(.vertical, 10)
    }
}