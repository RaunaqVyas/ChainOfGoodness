//
//  BlobView.swift
//  Chain Of Goodness
//
//  Created By Raunaq Vyas on 2023-03-26.
//


import SwiftUI

struct BlobView: View {
    @State var appear = false
    var body: some View {
        // Create a TimelineView that uses the .animation timeline
        TimelineView(.animation) { timeline in
            // Get the current time from the timeline
            let now = timeline.date.timeIntervalSinceReferenceDate
            // Calculate the angle based on the current time
            let angle = Angle.degrees(now.remainder(dividingBy: 3) * 60)
            // Calculate x based on the angle
            let x = cos(angle.radians)
            // Calculate a second angle based on the current time
            let angle2 = Angle.degrees(now.remainder(dividingBy: 6) * 10)
            // Calculate a second x value based on the second angle
            let x2 = cos(angle2.radians)
            
            // Create a Canvas view to draw the path
            Canvas { context, size in
                // Fill the path defined by the path(in:x:x2) function with a linear gradient
                context.fill(path(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), x: x, x2: x2), with: .linearGradient(Gradient(colors: [.pink, .blue]), startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 400, y: 400)))
                // FixME I gotta change the colour to match custom colours as well as create another blob for dark mode.
            }
            .frame(width: 400, height: 414)
            .rotationEffect(.degrees(appear ? 360 : 0))
        }
        .onAppear {
            // change state with on apear to cause rotation effect
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: true)) {
                appear = true
            }
            
        }
    }
    
    // Define the path that will be drawn by the Canvas view
    func path(in rect: CGRect, x: Double, x2: Double) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.9923*width, y: 0.42593*height))
        path.addCurve(to: CGPoint(x: 0.6355*width*x2, y: height), control1: CGPoint(x: 0.92554*width*x2, y: 0.77749*height*x2), control2: CGPoint(x: 0.91864*width*x2, y: height))
        path.addCurve(to: CGPoint(x: 0.08995*width, y: 0.60171*height), control1: CGPoint(x: 0.35237*width*x, y: height), control2: CGPoint(x: 0.2695*width, y: 0.77304*height))
        path.addCurve(to: CGPoint(x: 0.34086*width, y: 0.06324*height*x), control1: CGPoint(x: -0.0896*width, y: 0.43038*height), control2: CGPoint(x: 0.00248*width, y: 0.23012*height*x))
        path.addCurve(to: CGPoint(x: 0.9923*width, y: 0.42593*height), control1: CGPoint(x: 0.67924*width, y: -0.10364*height*x), control2: CGPoint(x: 1.05906*width, y: 0.07436*height*x2))
        path.closeSubpath()
        return path
    }
}

struct BlobView_Previews: PreviewProvider {
    static var previews: some View {
        BlobView()
    }
}
    

// Define a custom Shape that can be used to draw shapes
