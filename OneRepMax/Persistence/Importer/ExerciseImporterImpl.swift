//
//  ExerciseImporterImpl.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct ExerciseImporterImpl<Storage>: ExerciseImporter where Storage: ExerciseStorage {
    let exerciseStorage: Storage
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()
    
    func importExercises(from url: URL) {
        let logLines = readFile(at: url)
        var exerciseLogs: [String: [ExerciseLog]] = [:]

        logLines.forEach { log in
            // Date, name, sets, reps, weight

            // Avoid edge scenarios like blank lines, EOF, etc
            guard log.count == 5 else {
                return
            }

            let name = log[1]

            if !exerciseLogs.contains(where: { $0.0 == name }) {
                exerciseLogs[name] = []
            }
            
            guard let date = date(from: log[0]),
                  let sets = Int(log[2]),
                  let reps = Int(log[3]),
                  let weight = Double(log[4]) else {
                      return
                  }

            
            exerciseLogs[name]?.append(ExerciseLog(
                date: date,
                sets: sets,
                reps: reps,
                weight: weight,
                oneRepMax: calculateRM(for: weight, reps: reps)
            ))
        }
        
        let exercises = exerciseLogs.map { name, logs in
            Exercise(name: name, logs: logs)
        }
        
        do {
            // For simplicity, remove existing data before importing
            try exerciseStorage.deleteAll()
            try exerciseStorage.add(exercises: exercises)
        } catch {
            // TBD: Handle errors
        }
    }
}

private extension ExerciseImporterImpl {
    func readFile(at url: URL) -> [[String]] {
        guard let content = try? String(contentsOf: url) else {
            return []
        }

        return content.components(separatedBy: .newlines)
            .map { $0.components(separatedBy: ",") }
    }

    func date(from string: String) -> Date? {
        dateFormatter.date(from: string)
    }

    func calculateRM(for weight: Double, reps: Int) -> Double {
        // Brzycki Formula
        // See https://en.wikipedia.org/wiki/One-repetition_maximum
        let value = weight * Double((36 / (37 - reps)))
        // Round to one decimal place
        return round(value * 10) / 10.0
    }
}
