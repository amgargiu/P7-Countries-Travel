//
//  SearchBarView.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/27/26.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var textfieldText: String
    
    
    var body: some View {
        
        
        HStack {
            
            Image(systemName: "magnifyingglass")
            
            TextField("type here", text: $textfieldText)
            
            Image(systemName: "xmark.circle")
                .frame(width: 40, height: 20, alignment: .trailing)
                .foregroundStyle(Color(.tertiaryLabel))
                .onTapGesture {
                    self.textfieldText = ""
                }
        }
        .padding()
        .background(
            Capsule()
                .fill(Color(.secondarySystemBackground))
        )
        .shadow(radius: 10)
        .padding(.vertical)

    }
}

#Preview {
    SearchBarView(textfieldText: .constant(""))
}
