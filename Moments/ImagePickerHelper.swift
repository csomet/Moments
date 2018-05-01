//
//  ImagePickerHelper.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 13/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import UIKit
import MobileCoreServices


typealias imagePickerHelperCompletion = ((UIImage?) -> Void)?

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    //actionsheet, pickercontroller ==> Reference with the viewcontroler whatever it is.
    
    
    weak var viewController: UIViewController!
    var  completion: imagePickerHelperCompletion
    
    
    init(viewController: UIViewController, completion: imagePickerHelperCompletion){
        
        self.viewController = viewController
        self.completion = completion
        
        super.init()
        
        self.showPhotoSourceSelection()
        
    }
    
    
    func showPhotoSourceSelection() {
        
        //alert
       
        let actionSheet = UIAlertController(title: "Pick new Photo", message: "You must choose one picture or open camera", preferredStyle: .actionSheet)
        
        //possible actions (buttons)
        
        let cameraAction = UIAlertAction(title: "Open camera", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Select picture", style: .default) { (action) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(photoLibAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func showImagePicker (sourceType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        
        viewController.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion!(image)
        
        
    }
    

    
}
