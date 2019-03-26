//
//  ImageRecognizer.swift
//  Weather Recognizer App
//
//  Created by Toni Hoffmann on 26.03.19.
//  Copyright © 2019 Toni Hoffmann. All rights reserved.
//

import UIKit

class ImageRecognizer: NSObject {
    static func analyseImage(image: UIImage)->WeatherImageClassifierOutput?{
        let classifier = WeatherImageClassifier()
        do{
            let result = try classifier.prediction(image: ImageProcessor.pixelBuffer(forImage: image.cgImage!)!)

            return result
        }catch{

        }
        return nil
    }
}
