//
//  XMarkButton.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 3/4/26.
//


import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}