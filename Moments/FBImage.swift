//
//  FBImage.swift
//  Moments
//
//  Created by Carlos Herrera Somet on 12/4/17.
//  Copyright © 2017 Carlos H Somet. All rights reserved.
//

import Foundation
import Firebase



class FBIMage {
    
    
    
    var image: UIImage
    var downloadUrl: URL?
    var downloadLink: String?
    var ref: StorageReference!
    
    
    init(image: UIImage) {
        
        self.image = image
    }
    
    
    
    
}

extension FBIMage {
    
    func saveProfileImage(_ userUID: String, _ completion:  @escaping (Error?) -> Void){
        
        let resizedImage = image.resize()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = FBStorage.profileImages.reference().child(userUID)
        downloadLink = ref.description
        
        
        ref.putData(imageData!, metadata: nil) { (metadata, error) in
            completion(error)
        }
      
        
    }
    
    func saveImage (_ uid: String, completion: @escaping (Error?) -> Void) {
        
        let resizedImage = image.resize()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = FBStorage.images.reference().child(uid)
        downloadLink = ref.description
        
        ref.putData(imageData!, metadata: nil) { (metadata, error) in
            completion(error)
        }

        
    }
    
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void){
        
        FBStorage.profileImages.reference().child(uid).getData(maxSize: 15 * 1024 * 1024) { (imageData, error) in
            
            if (imageData != nil) {
                
                let image = UIImage(data: imageData!)
                completion(image, error)
                
            }else{
                completion(nil, error)
            }
        }

    }
    
    
    class func downloadImage(_ uid: String,_ completion:  @escaping (UIImage?, Error?) -> Void) {
        
        FBStorage.images.reference().child(uid).getData(maxSize: 15 * 1024 * 1024) { (imageData, error) in
          
            
            if (error == nil && imageData != nil) {
                
                let image = UIImage(data: imageData!)
                completion(image, error)
                
            }else{
                completion(nil, error)
            }
        }
        
        
        
        }

    
}

private extension UIImage{
    
    func resize() -> UIImage {
        
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in: newRect)
        
        let imageResized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageResized!
        
        
        
    }
}
