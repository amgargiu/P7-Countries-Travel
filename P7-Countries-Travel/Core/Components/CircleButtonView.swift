//
//  CircularButton.swift
//  P7-Countries-Travel
//
//  Created by Antonio Gargiulo on 2/22/26.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.black)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))            )
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}

#Preview {
    CircleButtonView(iconName: "plus")
}
