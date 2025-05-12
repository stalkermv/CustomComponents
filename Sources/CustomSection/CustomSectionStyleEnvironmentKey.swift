//
//  Created by Valeriy Malishevskyi on 10.06.2024.
//

import SwiftUI

struct CustomSectionStyleEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: any CustomSectionStyle = DefaultCustomSectionStyle()
}

extension EnvironmentValues {
    var customSectionStyle: any CustomSectionStyle {
        get { self[CustomSectionStyleEnvironmentKey.self] }
        set { self[CustomSectionStyleEnvironmentKey.self] = newValue }
    }
}
