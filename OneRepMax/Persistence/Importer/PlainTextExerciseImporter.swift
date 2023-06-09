//
//  PlainTextExerciseImporter.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 18/3/23.
//

import Foundation

struct PlainTextExerciseImporter: FileExerciseImporter {
    let exerciseStorage: ExerciseStorage

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter
    }()

    func handlesFile(with fileExtension: String) -> Bool {
        fileExtension == "txt"
    }

    func parseExercises(from url: URL) -> [Exercise] {
        let logLines = readFile(at: url)
        // By using a Set we avoid duplicates, saving some time in calculations
        var exerciseLogs: [String: Set<ExerciseLog>] = [:]

        logLines.forEach { log in
            // Date, name, sets, reps, weight

            // Avoid edge scenarios like blank lines, EOF, etc
            guard log.count == 5 else {
                return
            }

            let name = log[1]

            if !exerciseLogs.contains(where: { $0.0 == name }) {
                exerciseLogs[name] = Set()
            }

            guard let date = date(from: log[0]),
                  let sets = Int(log[2]),
                  let reps = Int(log[3]),
                  let weight = try? Decimal(log[4], format: .number) else {
                      return
                  }

            exerciseLogs[name]?.insert(ExerciseLog(
                id: UUID(),
                date: date,
                sets: sets,
                reps: reps,
                weight: weight
            ))
        }

        return exerciseLogs.map { name, logs in
            // Group workout logs for a given exercise by date to calculate the 1RM per date
            let grouped = Dictionary(grouping: logs, by: { $0.date })

            // The value we'll keep will be the max of all the calculated 1RM for the date
            let oneRepMaxs: [OneRepMax] = grouped.compactMap { date, groupedLogs in
                guard let oneRepMax = groupedLogs.map({
                    calculateRM(for: $0.weight, reps: $0.reps)
                }).max() else { return nil }

                return OneRepMax(id: UUID(), date: date, oneRepMax: oneRepMax)
            }

            return Exercise(
                id: UUID(),
                name: name,
                logs: Array(logs),
                oneRepMaxs: oneRepMaxs,
                overallOneRepMax: oneRepMaxs.max(by: { $0.oneRepMax < $1.oneRepMax })?.oneRepMax
            )
        }
    }
}

private extension PlainTextExerciseImporter {
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
        var value = weight * Decimal((36.0 / (37.0 - Double(reps))))
        var result = Decimal()
        // Round to one decimal place
        NSDecimalRound(&result, &value, 1, .plain)
        return result
    }
}
