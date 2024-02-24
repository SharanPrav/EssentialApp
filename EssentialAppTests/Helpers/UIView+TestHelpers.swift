//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Saranya Ravi on 23/02/2024.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
