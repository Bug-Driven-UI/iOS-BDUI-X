//
//  RoundedCornersShape.swift
//  bdui-x
//
//  Created by dark type on 02.10.2025.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    let tl: CGFloat
    let tr: CGFloat
    let bl: CGFloat
    let br: CGFloat

    init(_ rc: BduiShapeModel.RoundedCornersModel) {
        self.tl = CGFloat(rc.topStart)
        self.tr = CGFloat(rc.topEnd)
        self.bl = CGFloat(rc.bottomStart)
        self.br = CGFloat(rc.bottomEnd)
    }
    init(tl: CGFloat, tr: CGFloat, bl: CGFloat, br:CGFloat) {
        self.tl = tl
        self.tr = tr
        self.bl = bl
        self.br = br
    }

    func path(in rect: CGRect) -> SwiftUI.Path {
        var path = SwiftUI.Path()
        let w = rect.width
        let h = rect.height

        let tl = min(min(self.tl, h / 2), w / 2)
        let tr = min(min(self.tr, h / 2), w / 2)
        let bl = min(min(self.bl, h / 2), w / 2)
        let br = min(min(self.br, h / 2), w / 2)

        path.move(to: CGPoint(x: w / 2, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr),
                    radius: tr,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br),
                    radius: br,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl),
                    radius: bl,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl),
                    radius: tl,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}
