//
//  LoginView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/22.
//

import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: View {
    
    var body: some View {
        GoogleSignInButtonViewController()
    }
}

struct GoogleSignInButtonViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let gidSignInButton = GIDSignInButton()
        gidSignInButton.style = .wide
        let viewController = GoogleSignInViewController()
        viewController.view.addSubview(gidSignInButton)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
