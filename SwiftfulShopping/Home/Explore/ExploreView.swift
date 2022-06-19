//
//  ExploreView.swift
//  SwiftfulShopping
//
//  Created by Łukasz Janiszewski on 09/06/2022.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var authStateManager: AuthStateManager
    @EnvironmentObject private var tabBarStateManager: TabBarStateManager
    @EnvironmentObject private var exploreViewModel: ExploreViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(1...50, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    /// Here will be notifications
                    Button(action: {
                        withAnimation {
                            authStateManager.logoutCompletely()
                        }
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            
                        }
                    }, label: {
                        Image(systemName: "bell")
                    })
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
