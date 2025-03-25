//
//  TimerView.swift
//  CoreChal1
//
//  Created by Hendrik Nicolas Carlo on 24/03/25.
//

import SwiftUI

struct TimerView: View {
    @State private var isAnimating: Bool = false
    @State private var lineOffset: CGFloat = 0
    @State private var textOpacity: Double = 0
    @State private var textScale: CGFloat = 0.5
    @State private var workPulse: CGFloat = 1.0
    @State private var breakPulse: CGFloat = 1.0
    @State private var selectedMode: String? = nil
    @State private var workScale: CGFloat = 1.0
    @State private var breakScale: CGFloat = 1.0
    @State private var lineScale: CGFloat = 1.0
    @State private var workOffset: CGSize = .zero
    @State private var breakOffset: CGSize = .zero
    @State private var lineOffsetXY: CGSize = .zero
    @State private var workImageOpacity: Double = 0
    @State private var breakImageOpacity: Double = 0
    @State private var workDurationOpacity: Double = 0
    @State private var breakDurationOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            // Curved Line
            CurvedLine()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .frame(width: 300, height: 500)
                .scaleEffect(lineScale)
                .offset(lineOffsetXY)
                .animation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: true),
                    value: lineOffset
                )
                .animation(
                    Animation.spring(response: 0.5, dampingFraction: 0.6),
                    value: lineScale
                )
                .animation(
                    Animation.spring(response: 0.5, dampingFraction: 0.6),
                    value: lineOffsetXY
                )
                .onAppear {
                    lineOffset = 20
                }
            
            // Work Section
            VStack(spacing: 10) {
                Image(systemName: "person.fill.viewfinder") // Ganti dengan gambar orang bekerja
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .opacity(workImageOpacity)
                    .animation(
                        Animation.easeInOut(duration: 0.5),
                        value: workImageOpacity
                    )
                
                Text("Work")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .scaleEffect(textScale * workScale * workPulse)
                    .offset(workOffset)
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6)
                            .delay(0.2),
                        value: textScale
                    )
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: workPulse
                    )
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6),
                        value: workScale
                    )
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6),
                        value: workOffset
                    )
                
                Text("58 minutes")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(workDurationOpacity)
                    .animation(
                        Animation.easeInOut(duration: 0.5),
                        value: workDurationOpacity
                    )
            }
            .position(x: selectedMode == "Work" ? UIScreen.main.bounds.width / 2 : UIScreen.main.bounds.width / 4,
                      y: selectedMode == "Work" ? UIScreen.main.bounds.height / 2 : UIScreen.main.bounds.height / 4)
            .animation(
                Animation.spring(response: 0.5, dampingFraction: 0.6),
                value: selectedMode
            )
            .onTapGesture {
                withAnimation {
                    if selectedMode == "Work" {
                        selectedMode = nil
                        workScale = 1.0
                        breakScale = 1.0
                        lineScale = 1.0
                        workOffset = .zero
                        breakOffset = .zero
                        lineOffsetXY = .zero
                        workImageOpacity = 0
                        breakImageOpacity = 0
                        workDurationOpacity = 0
                        breakDurationOpacity = 0
                    } else {
                        selectedMode = "Work"
                        workScale = 1.5
                        breakScale = 0.5
                        lineScale = 0.5
                        workOffset = .zero
                        breakOffset = CGSize(width: 100, height: 200)
                        lineOffsetXY = CGSize(width: 100, height: 200)
                        workImageOpacity = 1
                        breakImageOpacity = 0
                        workDurationOpacity = 1
                        breakDurationOpacity = 0
                    }
                }
            }
            .onAppear {
                workPulse = 1.05
            }
            
            // Break Section
            VStack(spacing: 10) {
                Image(systemName: "figure.cooldown") // Ganti dengan gambar orang stretching
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .opacity(breakImageOpacity)
                    .animation(
                        Animation.easeInOut(duration: 0.5),
                        value: breakImageOpacity
                    )
                
                Text("Break")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .scaleEffect(textScale * breakScale * breakPulse)
                    .offset(breakOffset)
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6)
                            .delay(0.4),
                        value: textScale
                    )
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(0.3),
                        value: breakPulse
                    )
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6),
                        value: breakScale
                    )
                    .animation(
                        Animation.spring(response: 0.5, dampingFraction: 0.6),
                        value: breakOffset
                    )
                
                Text("5 minutes")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(breakDurationOpacity)
                    .animation(
                        Animation.easeInOut(duration: 0.5),
                        value: breakDurationOpacity
                    )
            }
            .position(x: selectedMode == "Break" ? UIScreen.main.bounds.width / 2 : 3 * UIScreen.main.bounds.width / 4,
                      y: selectedMode == "Break" ? UIScreen.main.bounds.height / 2 : 2 * UIScreen.main.bounds.height / 3)
            .animation(
                Animation.spring(response: 0.5, dampingFraction: 0.6),
                value: selectedMode
            )
            .onTapGesture {
                withAnimation {
                    if selectedMode == "Break" {
                        // Reset to initial state
                        selectedMode = nil
                        workScale = 1.0
                        breakScale = 1.0
                        lineScale = 1.0
                        workOffset = .zero
                        breakOffset = .zero
                        lineOffsetXY = .zero
                        workImageOpacity = 0
                        breakImageOpacity = 0
                        workDurationOpacity = 0
                        breakDurationOpacity = 0
                    } else {
                        // Zoom in Break
                        selectedMode = "Break"
                        breakScale = 1.5
                        workScale = 0.5
                        lineScale = 0.5
                        breakOffset = .zero
                        workOffset = CGSize(width: -100, height: -200)
                        lineOffsetXY = CGSize(width: -100, height: -200)
                        workImageOpacity = 0
                        breakImageOpacity = 1
                        workDurationOpacity = 0
                        breakDurationOpacity = 1
                    }
                }
            }
            .onAppear {
                breakPulse = 1.05
            }
        }
        .onAppear {
            withAnimation {
                textOpacity = 1
                textScale = 1
            }
        }
    }
}

struct CurvedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let controlPoint1 = CGPoint(x: rect.midX - 50, y: rect.maxY)
        let controlPoint2 = CGPoint(x: rect.midX + 50, y: rect.minY)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
        
        return path
    }
}

#Preview {
    TimerView()
}
