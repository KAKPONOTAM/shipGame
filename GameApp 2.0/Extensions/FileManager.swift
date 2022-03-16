import Foundation
import UIKit

extension FileManager {
    static func saveImage(_ image: UIImage) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString
        
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName),
              let imageData = image.pngData() else { return nil }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
}
