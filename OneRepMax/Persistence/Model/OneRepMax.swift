//
//  OneRepMax.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation

struct OneRepMax {
    /// Unique identifier for a given instance
    let id: UUID

    /// Date for the 1RM record
    let date: Date

    /// Value of the theoretical 1RM
    let oneRepMax: Decimal

    init(
        id: UUID,
        date: Date,
        oneRepMax: Decimal
    ) {
        self.id = id
        self.date = date
        self.oneRepMax = oneRepMax
    }
}
