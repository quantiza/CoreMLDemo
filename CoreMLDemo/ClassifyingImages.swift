//
//  Inceptionv3ViewController.swift
//  CoreMLDemo
//
//  Created by Yang Long on 2020/11/19.
//

import UIKit
import CoreML
import Vision

class ClassifyingImages: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    
    let imageNames = ["apple.jpg", "puppy.webp", "cat.webp", "girl.webp", "banana"]
    var imageIndex = 0
    @IBOutlet weak var confidenceLabel: UILabel!
    
    var request: VNCoreMLRequest!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = try! VNCoreMLModel(for: MobileNetV2().model)
        request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            DispatchQueue.main.async {
                guard let results = request.results else {
                    print("error")
                    return
                }
                let classifications = results as! [VNClassificationObservation]
                self?.updateConfidence(results: classifications)
            }
        }
        updateView()
    }
    
    @IBAction func previous(_ sender: Any) {
        
        imageIndex = (imageIndex == 0)
            ? imageNames.count - 1
            : imageIndex - 1
        
        updateView()
    }
    
    @IBAction func next(_ sender: Any) {
        
        imageIndex = (imageIndex == imageNames.count - 1)
            ? 0
            : imageIndex + 1
        updateView()
    }
    
    
    @IBAction func recognize(_ sender: Any) {
        
        guard let cgimage = imageView.image?.cgImage else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image = CIImage(cgImage: cgimage)
            print(image)
            let handler = VNImageRequestHandler(ciImage: image, orientation: .up)

            do {
                try handler.perform([self.request])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func updateView() {
        imageView.image = UIImage(named: imageNames[imageIndex])
        numLabel.text = "\(imageIndex)"
        confidenceLabel.text = ""
    }
    
    func updateConfidence(results: [VNClassificationObservation]) {
        
        var content = ""
        content.append("1. \(results[0].identifier)   confidence: \(results[0].confidence) \n \n")
        content.append("2. \(results[1].identifier)   confidence: \(results[1].confidence) \n \n")
        content.append("3. \(results[2].identifier)   confidence: \(results[2].confidence)")
        confidenceLabel.text = content
    }
}
