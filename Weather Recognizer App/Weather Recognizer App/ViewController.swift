//
//  ViewController.swift
//  Weather Recognizer App
//
//  Created by Toni Hoffmann on 26.03.19.
//  Copyright © 2019 Toni Hoffmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func analyseImage(image: UIImage){
        let result = ImageRecognizer.analyseImage(image: image)!
        let messageText = textBuilder(output: result)
        
        
        let alert = UIAlertController(title: "Alert", message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textBuilder(output: WeatherImageClassifierOutput)->String{
        var text = "It is "
        
        for (idx, weatherSituation) in output.classLabelProbs.keys.enumerated() {
            let probability = output.classLabelProbs[weatherSituation]
            if probability != nil{
                if(probability! > 0.3){
                    text.append(weatherSituation + " ")
                    if idx == output.classLabelProbs.keys.count-1{
                        text.append(".")
                    }else{
                        text.append("and ")
                    }
                }else if(probability! > 0.2){
                    text.append("a bit " + weatherSituation + " ")
                    if idx == output.classLabelProbs.keys.count-1{
                        text.append(".")
                    }else{
                        text.append("and ")
                    }
                }else{
                }
            }
            
        }
        return text
    }
    
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            analyseImage(image: image)
        }else{
            print("Oh oh...")
        }
    }
    
}

