//
//  ViewController.swift
//  Weather Recognizer App
//
//  Created by Toni Hoffmann on 26.03.19.
//  Copyright © 2019 Toni Hoffmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
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


        //        let alert = UIAlertController(title: "Alert", message: messageText, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
        resultLabel.text = messageText
    }

    func textBuilder(output: WeatherImageClassifierOutput)->String{
        var text = "It is "

        let situations = Array(output.classLabelProbs.keys).sorted(by: {output.classLabelProbs[$0]! > output.classLabelProbs[$1]!}).enumerated()


        //        let situations = output.classLabelProbs.keysSortedByValue(isOrderedBefore: >).enumerated()
        for (idx, weatherSituation) in situations {
            let probability = output.classLabelProbs[weatherSituation]
            if probability != nil{
                if probability! > 0.2{
                    if idx != 0{
                        text.append(" and ")
                    }
                }
                if(probability! > 0.4){
                    text.append("defnitly " + weatherSituation)
                }
                else if(probability! > 0.3){
                    text.append(weatherSituation)
                }else if(probability! > 0.2){
                    text.append("maybe a little bit " + weatherSituation)
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
            imageView.image = image
            analyseImage(image: image)
        }else{
            print("Oh oh...")
        }
    }

}




