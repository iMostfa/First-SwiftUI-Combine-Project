//
//  md.swift
//  wallet
//
//  Created by mostfa on 3/20/20.
//  Copyright © 2020 mostfa. All rights reserved.
//

import SwiftUI

struct ScaledCircle: Shape {
    var animatableData: CGFloat

    func path(in rect: CGRect) -> Path {
        let maximumCircleRadius = sqrt(rect.width * rect.width + rect.height * rect.height)
        let circleRadius = maximumCircleRadius * animatableData

        let x = rect.midX - circleRadius / 2
        let y = rect.midY - circleRadius / 2

        let circleRect = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)

        return Circle().path(in: circleRect)
    }
}
struct ClipShapeModifier<T: Shape>: ViewModifier {
    let shape: T

    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}
extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
            identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
        )
    }
}

struct ContentzView: View {
    private let objWidth = CGFloat(100)
     private let objHeight = CGFloat(200)
     private let screenWidth = UIScreen.main.bounds.size.width;
     private let screenHeight = UIScreen.main.bounds.size.height;
     @State private var objOffset = CGFloat(50)

     var body: some View {
         VStack {
             Rectangle()
                 .frame(width: objWidth, height: objHeight)
                 .background(Color.black)
                 .position(x: objOffset, y: (screenHeight-objHeight)/2.0)
             Button(action: {
                 withAnimation{
                     self.move()
                 }
             }) {
                 Text("TAP")
             }
         }
     }

     private func move() {
         if objOffset > screenWidth/2.0 {
             objOffset = objWidth/2.0
         } else {
             objOffset = screenWidth-objWidth/2.0
         }
     }
}
//ContentzView
struct ContentzVikew: PreviewProvider {
    static var previews: some View {
      ContentzView()
    }
}
