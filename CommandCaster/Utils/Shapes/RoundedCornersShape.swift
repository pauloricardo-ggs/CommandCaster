//
//  RoundedCornersShape.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 23/09/2024.
//

import SwiftUICore


struct RoundedCornersShape: Shape {
    var cornerRadius: CGFloat
    var corners: [Corner]

    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeftRadius = corners.contains(.topLeft) ? cornerRadius : 0
        let topRightRadius = corners.contains(.topRight) ? cornerRadius : 0
        let bottomLeftRadius = corners.contains(.bottomLeft) ? cornerRadius : 0
        let bottomRightRadius = corners.contains(.bottomRight) ? cornerRadius : 0

        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius),
                    radius: topRightRadius, startAngle: Angle.degrees(-90), endAngle: Angle.degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addArc(center: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius),
                    radius: bottomRightRadius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius),
                    radius: bottomLeftRadius, startAngle: Angle.degrees(90), endAngle: Angle.degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius, startAngle: Angle.degrees(180), endAngle: Angle.degrees(270), clockwise: false)

        return path
    }
}
