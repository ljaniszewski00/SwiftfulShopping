import SwiftUI

struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    var showScrollIndicators: Bool = false
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        contentOverflow = contentGeometry.size.height > geometry.size.height
                    }
                }
            )
            .wrappedInScrollView(when: contentOverflow, showScrollIndicators: showScrollIndicators)
        }
    }
}

extension View {
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool, showScrollIndicators: Bool = false) -> some View {
        if condition {
            ScrollView(showsIndicators: showScrollIndicators) {
                self
            }
        } else {
            self
        }
    }
}

extension View {
    func scrollOnOverflow(showScrollIndicators: Bool = false) -> some View {
        modifier(OverflowContentViewModifier(showScrollIndicators: showScrollIndicators))
    }
}
