//
//  ListCell.swift
//  CoordinatorApp
//
//  Created by Dre on 11/08/2021.
//

import SwiftUI

public struct ListCell: View {
    public let text: String
    public let action: () -> Void

    public var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .opacity(0.8)
            }
        }
    }
}
