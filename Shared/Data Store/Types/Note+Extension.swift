//
//  Note+Extension.swift
//  DeDuplicatingEntity Sample
//
//  Created by Victor Hudson on 1/16/22.
//

import Foundation
import CoreData
import DeDuplicatingEntity

extension Note: DeDuplicatingEntity {
    public func moveRelationships(to destination: Note) {
        // nothing to do here
    }
}

