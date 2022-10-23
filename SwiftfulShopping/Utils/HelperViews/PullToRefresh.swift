//
//  PullToRefresh.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 23/10/2022.
//

import SwiftUI

 /// Should be put into ScrollView.
 /// ScrollView should have the same value of .coordinateSpace modifier as PullToRefresh coordinateSpace var
 struct PullToRefresh: View {
     var coordinateSpace: CoordinateSpace = .named(PullToRefreshConstants.coordinateSpaceName)
     var onRefresh: () -> Void
     @State var refresh: Bool = false

     var body: some View {
         GeometryReader { geometry in
             if geometry.frame(in: coordinateSpace).midY >
                    PullToRefreshConstants.geometryFrameMidYBottomBorder {
                 Spacer()
                     .onAppear {
                         onRefresh()
                         refresh = true
                     }
             } else if geometry.frame(in: coordinateSpace).maxY <
                        PullToRefreshConstants.geometryFrameMaxYTopBorder {
                 Spacer()
                     .onAppear {
                         refresh = false
                     }
             }
             if refresh {
                 ProgressView()
                     .frame(width: geometry.size.width)
                     .padding(.top, PullToRefreshConstants.progressViewTopPadding)
                     .scaleEffect(PullToRefreshConstants.progressViewScaleEffectMultiplier)
             }
         }
     }
 }

 struct PullToRefreshDemo: View {
     var body: some View {
         ScrollView {
             PullToRefresh {
                 // Refresh view here
             }
             Text("Some view...")
         }.coordinateSpace(name: "pullToRefresh")
     }
 }

 struct PullToRefresh_Previews: PreviewProvider {
     static var previews: some View {
         PullToRefreshDemo()
     }
 }

 private extension PullToRefresh {
     struct PullToRefreshConstants {
         static let coordinateSpaceName: String = "PullToRefresh"
         static let geometryFrameMidYBottomBorder: CGFloat = 40
         static let geometryFrameMaxYTopBorder: CGFloat = 1
         static let progressViewTopPadding: CGFloat = -50
         static let progressViewScaleEffectMultiplier: CGFloat = 1.3
     }
 }
