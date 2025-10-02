//
//  ErrorScreen.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

// MARK: - Error Screen analogous to Compose ErrorScreen / RetryButton

struct ErrorScreen: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().layoutPriority(1)

            Image("exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 109, height: 180)
                .accessibilityHidden(true)

            Spacer().frame(height: 16)

            Text("Something went wrong")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .foregroundColor(.primary)

            Spacer().frame(height: 6)

            Text("Error")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .foregroundColor(.primary)

            Spacer().layoutPriority(1)

            RetryButton(onClick: onRetry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


}

// MARK: - Retry Button

private struct RetryButton: View {
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            Text("Retry")

                .foregroundColor(.primary)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.secondary)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .accessibilityIdentifier("error_retry_button")
    }
}
