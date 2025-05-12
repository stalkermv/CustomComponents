//
//  Created by Valeriy Malishevskyi on 10.06.2024.
//

import SwiftUI

struct DefaultCustomSectionStyle: CustomSectionStyle {
    func makeBody(configuration: Configuration) -> some View {
        Section {
            configuration.content
        } header: {
            configuration.header
        } footer: {
            configuration.footer
        }
    }
}
