//  Created by Raunaq Vyas on 2023-04-30.
//

import SwiftUI

struct ChainItem: View {
    var namespace: Namespace.ID
    var chain: Chain = chains[0]
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(chain.title)
                    .font(.largeTitle.weight(.bold))
                    .matchedGeometryEffect(id: "title\(chain.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(chain.text.uppercased())
                    .font(.footnote.weight(.semibold))
                    .matchedGeometryEffect(id: "subtitle\(chain.id)", in: namespace)
                Text(chain.text)
                    .font(.footnote)
                    .matchedGeometryEffect(id: "text\(chain.id)", in: namespace)
            }
            .padding(20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .blur(radius: 30)
                    .matchedGeometryEffect(id: "blur\(chain.id)", in: namespace)
            )
        }
        .foregroundStyle(.white)
        .background(
            Image(chain.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
                .matchedGeometryEffect(id: "image\(chain.id)", in: namespace)
        )
        .background(
            Image(chain.background)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "background\(chain.id)", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .matchedGeometryEffect(id: "mask\(chain.id)", in: namespace)
        )
        .frame(height: 300)
    }
}

struct ChainItem_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ChainItem(namespace: namespace, show: .constant(true))
    }
}
