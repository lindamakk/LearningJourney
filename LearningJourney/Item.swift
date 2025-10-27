//
//  Item.swift
//  LearningJourney
//
//  Created by Linda on 27/10/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
