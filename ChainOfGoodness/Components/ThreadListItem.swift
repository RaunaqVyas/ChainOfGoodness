//
//  ThreadListItem.swift
//  ChainOfGoodness
//
//  Created by Raunaq Vyas on 2024-01-16.
//

import SwiftUI

struct ThreadListItem: View {
    var thread: Thread
    var onSelect: () -> Void
    @EnvironmentObject var sessionManager: SessionManager
    

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top, spacing: 12) {
                AsyncImageView(imageKey: thread.image ?? "", sessionManager: sessionManager)
                    .frame(width: 44, height: 44)
                    .background(Color(hex:thread.Colour))
                    .mask(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(thread.title)
                        .bold()
                        .foregroundColor(.primary)
                    Text(thread.description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.vertical, 4)
        }
    }
}


