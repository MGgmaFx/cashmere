//
//  PageView.swift
//  cashmere
//
//  Created by 志村豪気 on 2021/02/04.
//

import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @Binding var currentPage: Int

    init(_ views: [Page], currentPage: Binding<Int>) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        self._currentPage = currentPage
    }

    var body: some View {
        VStack {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
        }
    }
}
