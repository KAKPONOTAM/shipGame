import Foundation

extension String {
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
}
