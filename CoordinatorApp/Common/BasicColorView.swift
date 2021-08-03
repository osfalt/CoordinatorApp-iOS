//
//  BasicColorView.swift
//  CoordinatorApp
//
//  Created by Dre on 31/07/2021.
//

import SwiftUI

struct BasicColorView: View {
    let title: String
    let description: String?
    let color: Color
    let onNext: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text(title)
                .font(.title)
                .foregroundColor(.white)

            if let description = description {
                Text(description)
                    .multilineTextAlignment(.center)
                    .frame(alignment: .center)
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: { onNext?() }) {
                Text("Next")
                    .padding(
                        EdgeInsets(
                            top: 5,
                            leading: 20,
                            bottom: 5,
                            trailing: 20
                        )
                    )
                    .background(
                        Rectangle()
                            .foregroundColor(.white.opacity(0.8))
                            .cornerRadius(12)
                    )
                    .font(.title2)
                    .padding()
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
    }
}

struct BasicColorView_Previews: PreviewProvider {
    static var previews: some View {
        BasicColorView(
            title: "Title",
            description: "This is the test screen with orange background colour",
            color: .orange,
            onNext: nil
        )
    }
}
