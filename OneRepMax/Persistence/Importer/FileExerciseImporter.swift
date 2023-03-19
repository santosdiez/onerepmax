//
//  ExerciseImporterImpl.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct FileExerciseImporter: ExerciseImporter {
    let exerciseStorage: ExerciseStorage
    
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
                  let weight = try? Decimal(log[4], format: .number) else {
                      return
                  }

            
            exerciseLogs[name]?.append(ExerciseLog(
                date: date,
                sets: sets,
                reps: reps,
                weight: weight
            ))
        }
        
        let exercises: [Exercise] = exerciseLogs.map { name, logs in
            // Group workout logs for a given exercise by date to calculate the 1RM per date
            let grouped = Dictionary(grouping: logs, by: { $0.date })
            
            // The value we'll keep will be the max of all the calculated 1RM for the date
            let oneRepMaxs: [OneRepMax] = grouped.compactMap { date, groupedLogs in
                guard let oneRepMax = groupedLogs.map({
                    calculateRM(for: $0.weight, reps: $0.reps)
                }).max() else { return nil }

                return OneRepMax(date: date, oneRepMax: oneRepMax)
            }

            return Exercise(
                name: name,
                logs: logs,
                oneRepMaxs: oneRepMaxs,
                overallOneRepMax: oneRepMaxs.max(by: { $0.oneRepMax < $1.oneRepMax })?.oneRepMax
            )
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

private extension FileExerciseImporter {
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

    func calculateRM(for weight: Decimal, reps: Int) -> Decimal {
        // Brzycki Formula
        // See https://en.wikipedia.org/wiki/One-repetition_maximum
        var value = weight * Decimal((36 / (37 - reps)))
        var result = Decimal()
        // Round to one decimal place
        NSDecimalRound(&result, &value, 1, .plain)
        return result
    }
}
