//
//  ErrorScreen.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//
import SwiftUI


struct ErrorScreen: View {
    @Environment(\.bduiColors) private var colors
    @Environment(\.bduiTypography) private var typography

    let onRetry: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image("unknown_error")
                .resizable()
                .frame(width: 109, height: 180)
            Spacer().frame(height: 16)
            Text(NSLocalizedString("general_error_title", comment: ""))
                .foregroundStyle(colors.textPrimary)
                .font(typography.H20_H2.font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer().frame(height: 6)
            Text(NSLocalizedString("general_error_description", comment: ""))
                .foregroundStyle(colors.textPrimary)
                .font(typography.M10_P.font)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Spacer()
            RetryButton(onClick: onRetry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct RetryButton: View {
    @Environment(\.bduiColors) private var colors
    @Environment(\.bduiTypography) private var typography

    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            Text(NSLocalizedString("general_error_button_text", comment: ""))
                .font(typography.M20_P.font)
                .foregroundStyle(colors.buttonTextPrimary)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colors.buttonBgPrimary)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
