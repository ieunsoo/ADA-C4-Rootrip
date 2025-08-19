//
//  Extension + sectionButtonLabel.swift
//  Rootrip
//
//  Created by eunsoo on 8/18/25.
//
import SwiftUI

extension View {
    func sectionButtonLabel(isSelected: Bool) -> some View {
        self.modifier(SectionButtomLabel(isSelected: isSelected))
    }
}
