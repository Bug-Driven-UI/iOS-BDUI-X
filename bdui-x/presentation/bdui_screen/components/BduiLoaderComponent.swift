//
//  BduiLoaderComponent.swift
//  bdui-x
//
//  Created by dark type on 19.10.2025.
//

import SwiftUI
public struct BduiLoaderComponent: View {
    public var color: Color = .black
    public var strokeWidth: CGFloat = 3
    
    public var sweepFraction: CGFloat = 0.75

    @State private var isAnimating = false

    public init(
        color: Color = .black,
        strokeWidth: CGFloat = 3,
        sweepFraction: CGFloat = 0.75
    ) {
        self.color = color
        self.strokeWidth = strokeWidth
        self.sweepFraction = sweepFraction
    }

    public var body: some View {
        Canvas { context, size in
            
            let minDim = min(size.width, size.height)
            let sw = min(strokeWidth, minDim / 3.0)
            let inset = sw / 2.0
            let rect = CGRect(x: inset, y: inset, width: size.width - sw, height: size.height - sw)

            var path = SwiftUI.Path()
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2.0,
                startAngle: .degrees(0),
                endAngle: .degrees(Double(360.0 * sweepFraction)),
                clockwise: false
            )

            let style = StrokeStyle(lineWidth: sw, lineCap: .round)
            context.stroke(path, with: .color(color), style: style)
        }
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
        .onAppear { isAnimating = true }

        .frame(width: 24, height: 24)
    }
}
