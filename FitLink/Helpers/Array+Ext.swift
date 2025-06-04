//
//  Array+Ext.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 31.05.2025.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        (indices.contains(index)) ? self[index] : nil
    }
}
