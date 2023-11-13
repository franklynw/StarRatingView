//
//  StarRatingView.swift
//
//  Created by Franklyn Weber on 24/03/2021.
//

import SwiftUI
import MapKit


public struct StarRatingView: View {
    
    private var width: CGFloat?
    private var starWidth: CGFloat?
    
    // using the UIColors because they're brighter
    private var baseColor = Color(Self.defaultBaseColor)
    private var highlightedColor = Color(.yellow)
    private var outline: Outline?
    private var spacing: CGFloat = 5
    
    @Binding private var userRating: Double
    @State private var privateUserRating: Double = 0 // because updating a @Binding var doesn't make the UI update
    @State private var overallWidth: CGFloat = 0
    
    private static let defaultBaseColor = UIColor(white: 0.84, alpha: 1)
    
    private struct Outline {
        let color: Color
        let weight: Font.Weight?
    }
    
    
    public init(rating: Double) {
        _userRating = Binding<Double>(get: { rating }, set: { _ in })
    }
    
    public init(rating: Binding<Double>) {
        _userRating = rating
    }
    
    public var body: some View {
        
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { value in
                if (value.translation.width == 0 && value.translation.height == 0) || abs(value.translation.width) <= abs(value.translation.height) {
                    return
                }
                privateUserRating = value.location.x / overallWidth * 5
            }
            .onEnded { value in
                guard (value.translation.width == 0 && value.translation.height == 0) || abs(value.translation.width) > abs(value.translation.height) else {
                    return
                }
                privateUserRating = value.location.x / overallWidth * 5
            }
        
        GeometryReader { proxy in
            HStack(spacing: spacing) {
                ForEach(Array(1...5), id: \.self) { index in
                    ZStack {
                        greyStar
                        star(amountShown: CGFloat(index) > privateUserRating ? max(privateUserRating - CGFloat(index - 1), 0) : 1)
                        starOutline(amountShown: CGFloat(index) > privateUserRating ? max(privateUserRating - CGFloat(index - 1), 0) : 1)
                    }
                }
            }
            Do {
                overallWidth = proxy.size.width
            }
        }
        .frame(width: width, height: actualStarWidth)
        .gesture(drag)
        .onAppear {
            privateUserRating = userRating
        }
        .onChange(of: privateUserRating) { rating in
            userRating = rating
        }
    }
    
    @ViewBuilder
    private var greyStar: some View {
        
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(baseColor)
            .frame(width: actualStarWidth, height: actualStarWidth, alignment: .leading)
    }
    
    @ViewBuilder
    private func star(amountShown: CGFloat) -> some View {
        
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(highlightedColor)
            .frame(width: actualStarWidth, height: actualStarWidth, alignment: .leading)
            .mask(mask(amountShown: amountShown))
    }
    
    @ViewBuilder
    private func starOutline(amountShown: CGFloat) -> some View {
        
        Image(systemName: "star")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .font(Font.body.weight(outline?.weight ?? .light))
            .foregroundColor(outline?.color ?? highlightedColor)
            .frame(width: actualStarWidth, height: actualStarWidth, alignment: .leading)
            .mask(mask(amountShown: amountShown))
    }
    
    @ViewBuilder
    private func mask(amountShown: CGFloat) -> some View {
        
        if let starWidth = actualStarWidth {
            Rectangle()
                .fill(Color.black)
                .frame(width: starWidth * amountShown, height: starWidth, alignment: .leading)
                .offset(x: ((1 - amountShown) * starWidth) / -2)
        } else {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.black)
                    .frame(width: geometry.size.width * amountShown, height: geometry.size.width, alignment: .leading)
            }
        }
    }
    
    private var actualStarWidth: CGFloat? {
        if let starWidth = starWidth {
            return starWidth
        } else {
            return width != nil ? width! / 25 * 4 : nil
        }
    }
}


extension StarRatingView {
    
    public func width(_ width: CGFloat) -> Self {
        var copy = self
        copy.width = width
        return copy
    }
    
    public func starWidth(_ starWidth: CGFloat) -> Self {
        var copy = self
        copy.starWidth = starWidth
        return copy
    }
    
    public func baseColor(_ baseColor: Color) -> Self {
        var copy = self
        copy.baseColor = baseColor
        return copy
    }
    
    public func highlightedColor(_ highlightedColor: Color) -> Self {
        var copy = self
        copy.highlightedColor = highlightedColor
        return copy
    }
    
    public func outline(_ color: Color, weight: Font.Weight? = nil) -> Self {
        var copy = self
        copy.outline = Outline(color: color, weight: weight)
        return copy
    }
}


fileprivate struct Do: View {
    
    init(action: @escaping () -> ()) {
        DispatchQueue.main.async {
            action()
        }
    }
    
    var body: some View {
        EmptyView()
    }
}
