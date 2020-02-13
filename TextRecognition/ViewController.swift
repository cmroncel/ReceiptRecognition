//
//  ViewController.swift
//  TextRecognition
//
//  Created by Cemre ÖNCEL on 11.02.2020.
//  Copyright © 2020 Accecare. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lblTotalPoint: UILabel!
    @IBOutlet weak var btnCaptureReceipt: UIButton!
    
    
    static let minImageWidth : CGFloat = 300.0
    static let minImageHeight : CGFloat = 300.0
    
    var textRecognizer : VisionTextRecognizer!
    var imageReceipt : UIImage!
    
    var specifiedWords = ["pantene", "orkid", "gillette"]
    
    var userPoint : Int = 0
    static let receiptPoint : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        
        btnCaptureReceipt.layer.cornerRadius = 10
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageReceipt = pickedImage
            
            if pickedImage.size.width > ViewController.minImageWidth || pickedImage.size.height > ViewController.minImageHeight {
                imageReceipt = ImageHelper.fitImageSizeForVision(image: pickedImage)
            }
            
            imageReceipt = ImageHelper.compressImage(image: imageReceipt, imageQuality: .mediumQuality)
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        let visionImage = VisionImage(image: imageReceipt)
        
        textRecognizer.process(visionImage) { (features, error) in
            let visionResult : VisionHelper.VisionResult = VisionHelper.processResult(text: features, specifiedWords: self.specifiedWords, error: error)
            
            self.updateUIAfterProcess(visionResult: visionResult)
        }
    }
    
    func updateUIAfterProcess(visionResult: VisionHelper.VisionResult) {
        if visionResult == .found {
            userPoint += ViewController.receiptPoint
            
            let alertController = UIAlertController(title: "Tebrikler :)", message:
                "Fişinizden toplam \(ViewController.receiptPoint) puan kazandınız.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yeniden Çek", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
            lblTotalPoint.text = "Toplam Puan: \(userPoint)"
        } else {
            let alertController = UIAlertController(title: "Puan Kazanamadınız :(", message:
                "Fişinizde 'Pantene, Gillette, Orkid' ürünlerinden herhangi biri bulunmamaktadır.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yeniden Çek", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

