//
//  SplashScreen.swift
//  CarCare
//
//  Created by Giovanni Nembhard on 11/29/25.
//

import SwiftUI

struct SplashScreen: View {
    var onFinish: () -> Void

    @State private var fadeInName = false
    @State private var carOffset: CGFloat = -150
    @State private var carBounce = false

    let splashDuration: Double = 3.0

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()

            VStack(spacing: 50) {
                Text("Giovanni Nembhard Z23567778")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(fadeInName ? 1 : 0)
                    .animation(.easeIn(duration: 1.5), value: fadeInName)

                Image(systemName: "car.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .offset(x: carOffset, y: carBounce ? -10 : 0)
                    .animation(.easeOut(duration: 2), value: carOffset)
                    .animation(
                        Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                        value: carBounce
                    )
            }
        }
        .onAppear {
            fadeInName = true
            carOffset = 0
            carBounce = true

            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                onFinish() // Switch to main app
            }
        }
    }
}

