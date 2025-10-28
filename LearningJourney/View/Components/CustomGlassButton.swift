
//
//  onboarding.swift
//  learning_journey
//
//  Created by Linda on 16/10/2025.
//
//
import SwiftUI

struct CustomGlassButton: View {
    var title: String? = nil
    var image: Image? = nil
    var isSecondary: Bool = false
    var isActive: Bool = false
    var width: CGFloat = 90
    var height: CGFloat = 48
    var isNavigationLinkLabel: Bool = false
    var isDisabled: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if isNavigationLinkLabel {
                content
            } else {
                Button(action: { action?() }) {
                    content
                }
                .disabled(isDisabled)
            }
        }
        .foregroundColor(.white)
        .frame(width: width, height: height)
        .glassEffect(
            isDisabled // Check if the button is disabled
            ? .clear.tint(.gray.opacity(0.2)).interactive() // Grayed-out appearance
            : (isActive // If not disabled, check if it is pressed
                ? (isSecondary
                    ? .regular.tint(.appSecondary.opacity(1)).interactive()
                    : .regular.tint(.accent.opacity(1)).interactive())
                : .clear.tint(.gray.opacity(0.2)).interactive())
        )
    }

    private var content: some View {
        Group {
            if let image {
                image
                    .font(.title3)
                    .scaledToFit()
            } else if let title {
                Text(title)
                    .font(height <= 48 ? .headline : .largeTitle)
                    .fontWeight(height <= 48 ? .regular : .bold)
            }
        }
    }
}
