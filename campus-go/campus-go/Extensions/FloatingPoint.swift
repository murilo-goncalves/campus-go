//
//  FloatingPoint.swift
//  campus-go
//
//  Created by Vitor Jundi Moriya on 28/10/21.
//

import Foundation

internal extension FloatingPoint {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return max(min(self, range.upperBound), range.lowerBound)
    }
}

