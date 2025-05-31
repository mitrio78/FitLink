//
//  Untitled.swift
//  FitLink
//
//  Created by Дмитрий Гришечко on 30.05.2025.
//

import Foundation
import SwiftUI

struct SuperSetView: View {
    let sets: [SupersetApproach]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(sets.enumerated()), id: \.element.id) { (index, approach) in
                SupersetApproachView(index: index, approach: approach)
            }
        }
    }
}
