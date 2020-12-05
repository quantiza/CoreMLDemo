//
//  VisionBasicViewController.swift
//  CoreMLDemo
//
//  Created by Yang Long on 2020/12/5.
//

import UIKit
import Vision

class VisionBasicViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
        
    lazy var rectangleDetectionRequest = VNDetectRectanglesRequest { (request: VNRequest, error: Error?) in
        guard let results = request.results as? [VNRectangleObservation] else {
            print("rectangleDetectionRequest error ...")
            return
        }
        print(results)
    }
    
    lazy var faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
        guard let results = request.results as? [VNFaceObservation] else {
            print("faceDetectionRequest error ...")
            return
        }
        // [<VNFaceObservation: 0x102f77ed0> 5C17ED71-64FC-4D0F-AEEB-14AD233E315C
        // requestRevision=2 confidence=1.000000 timeRange={{0/1 = 0.000}, {0/1 = 0.000}}
        // boundingBox=[0.104073, 0.107256, 0.524025, 0.6987]]
        print(results)
        self.draw(observations: results)
    }
    
    lazy var faceLandmarkRequest = VNDetectFaceLandmarksRequest { (request, error) in
        guard let results = request.results as? [VNFaceObservation] else {
            print("faceLandmarkRequest error ...")
            return
        }
        print(results)
    }
    
    lazy var textDetectionRequest = VNDetectTextRectanglesRequest { (request, error) in
        guard let results = request.results as? [VNTextObservation] else {
            print("textDetectionRequest error ...")
            return
        }
        print(results)
        self.draw(observations: results)
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // 1. VNImageRequestHandler
    
    // 2. VNSequenceRequestHandler
    // An object that processes image analysis requests for each frame in a sequence.
    
    func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: image,
                                                        orientation: orientation,
                                                        options: [:])
        do {
            try imageRequestHandler.perform([faceDetectionRequest, textDetectionRequest])
        } catch {
            print("Failed to perform image request")
        }
    }
    
    func draw(observations:[VNDetectedObjectObservation]) {
        for obserVation in observations {
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView.frame.size.height)
            let translate = CGAffineTransform.identity.scaledBy(x: self.imageView.frame.size.width, y: self.imageView.frame.size.height)
            
            let rect = obserVation.boundingBox.applying(translate).applying(transform)
            
            let rectView = UIView(frame: rect)
            
            rectView.layer.borderWidth = 1
            rectView.layer.borderColor = UIColor.red.cgColor
            
            self.imageView.addSubview(rectView)
        }
    }
}


// MARK: - Present Photo Camera

extension VisionBasicViewController {
    @IBAction func choosePhoto(_ sender: Any) {
        let prompt = UIAlertController(title: "Choose a Photo",
                                       message: "Please choose a photo.",
                                       preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        func presentCamera(_ _: UIAlertAction) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: presentCamera)
        
        func presentLibrary(_ _: UIAlertAction) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library",
                                          style: .default,
                                          handler: presentLibrary)
        
        func presentAlbums(_ _: UIAlertAction) {
            imagePicker.sourceType = .savedPhotosAlbum
            self.present(imagePicker, animated: true)
        }
        
        let albumsAction = UIAlertAction(title: "Saved Albums",
                                         style: .default,
                                         handler: presentAlbums)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        prompt.addAction(cameraAction)
        prompt.addAction(libraryAction)
        prompt.addAction(albumsAction)
        prompt.addAction(cancelAction)
        
        self.present(prompt, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension VisionBasicViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage: UIImage = info[.originalImage] as! UIImage
        
        imageView.image = originalImage
        
        if let cgImage = originalImage.cgImage,
           let cgOrientation = CGImagePropertyOrientation(rawValue: UInt32(originalImage.imageOrientation.rawValue)) {
            performVisionRequest(image: cgImage, orientation: cgOrientation)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
