import Foundation
import UIKit

extension UIButton {
    func defaultShadowSetup() {
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = self.layer.cornerRadius
        self.layer.shadowOffset = CGSize(width: -3, height: -3)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


