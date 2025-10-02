//
//  BduiLoaderView.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct BduiLoaderView: View {
    let color: Color
    let strokeWidth: CGFloat

    @State private var rotation: Angle = .degrees(0)

    init(color: Color = .black, strokeWidth: CGFloat = 3) {
        self.color = color
        self.strokeWidth = strokeWidth
    }

    var body: some View {
        GeometryReader { geo in
            let minSide = min(geo.size.width, geo.size.height)
            let effectiveStroke = min(strokeWidth, minSide / 3.0)
            LoaderArcShape(sweepFraction: 0.75)
                .stroke(color, style: StrokeStyle(lineWidth: effectiveStroke,
                                                  lineCap: .round))
                .rotationEffect(rotation)
                .animation(.linear(duration: 1).repeatForever(autoreverses: false),
                           value: rotation)
                .onAppear {
                    rotation = .degrees(360)
                }
        }
    }
}

private struct LoaderArcShape: Shape {
    let sweepFraction: CGFloat

    func path(in rect: CGRect) -> Path {
        let startAngle = Angle.degrees(0)
        let sweepAngle = 360.0 * sweepFraction
        let endAngle = Angle.degrees(sweepAngle)
        let inset: CGFloat = 0
        let r = min(rect.width, rect.height) / 2 - inset
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var p = Path()
        p.addArc(center: center,
                 radius: r,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: false)
        return p
    }
}
