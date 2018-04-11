/**
 *  https://github.com/tadija/AETransition
 *  Copyright (c) Marko Tadić 2014-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

public extension CustomDebugStringConvertible {
    public var debugDescription: String {
        let typeDescription = String(describing: type(of: self))
        let properties = Mirror(reflecting: self).children.map({ "\($0.label ?? ""): \($0.value)" })
        if properties.count > 0 {
            return "\(typeDescription) (\(properties.joined(separator: ", ")))"
        } else {
            return "\(typeDescription)"
        }
    }
}
