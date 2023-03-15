//
//  Extensions.swift
//  Instagram-clone
//
//  Created by Tsenguun on 14/3/23.
//

import Foundation
import UIKit

extension UIView {
    var top: CGFloat {
        frame.origin.y
    }
    var bottom: CGFloat {
        frame.origin.y+height
    }
    var left: CGFloat {
        frame.origin.x
    }
    var right: CGFloat {
        frame.origin.x+width
    }
    var width: CGFloat {
        frame.size.width
    }
    var height: CGFloat {
        frame.size.height
    }
}

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [String: Any]
        
        return json
    }
}
