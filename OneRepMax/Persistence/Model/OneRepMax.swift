//
//  OneRepMax.swift
//  OneRepMax
//
//  Created by Borja Santos-Díez on 19/3/23.
//

import Foundation

struct OneRepMax {
    let id: ObjectIdentifier?
    let date: Date
    let oneRepMax: Decimal
    
    init(
        id: ObjectIdentifier? = nil,
        date: Date,
        oneRepMax: Decimal
    ) {
        self.id = id
        self.date = date
        self.oneRepMax = oneRepMax
    }
}
