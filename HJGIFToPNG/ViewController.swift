//
//  ViewController.swift
//  HJGIFToPNG
//
//  Created by Mr.H on 2017/7/10.
//  Copyright © 2017年 Mr.H. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = "/Users/xiaojie/Desktop/未命名文件夹"
        
        inputFolderPath(folderPath: path )
        
    }
    
    /// 分割组合图片路径
    func inputFolderPath(folderPath: String){
        
        let fileManager = FileManager.default
        
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: folderPath)!
        
        for temp in enumerator.enumerated() {
            
            let threeImage = (temp.element as! String)
            
            if threeImage.hasSuffix(".gif") {
                
                let name = threeImage.components(separatedBy: ".")[0]
                
                let pathName = folderPath + "/" + name
                
                let savePath = pathName + "/" + threeImage
                
                let pathString = folderPath + "/" + threeImage
                
                creatFile(path: pathName)
                
                threeTimesThePicturesTwoTimes(pathFile: pathString,savePath:savePath,index: temp.offset)
                
            }
            
        }
        
    }
    
    /// 保存图片到本地
    func threeTimesThePicturesTwoTimes(pathFile: String,savePath: String,index: Int){
        
        let nsd = NSData.init(contentsOfFile: pathFile)
        
        let images = getImages(data: nsd!)
        
        for temp in images.enumerated() {
            
            let arrayString = savePath.components(separatedBy: "/")
            
            let pathfiles = arrayString[arrayString.count - 1]
            
            let pathS = savePath as NSString
            
            let imageName = pathS.replacingOccurrences(of: pathfiles, with: String(temp.offset)) + ".png"
            
            let filePath:String = imageName as String
            
            let data:NSData = UIImagePNGRepresentation(temp.element)! as NSData
            
            data.write(toFile: filePath, atomically: true)
            
        }
        
    }
    
    /// 获取gif图片数据
    func getImages(data:NSData) -> [UIImage] {
        
        let options: NSDictionary = [kCGImageSourceShouldCache as String: NSNumber(value: true), kCGImageSourceTypeIdentifierHint as String: "CFString"]
        
        let imageSource = CGImageSourceCreateWithData(data, options)
        
        /// 获取gif帧数
        let frameCount = CGImageSourceGetCount(imageSource!)
        
        var images = [UIImage]()
        
        for i in 0 ..< frameCount {
            
            /// 获取对应帧的 CGImage
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource!, i, options) else { return images }
            
            /// 获取帧的img
            let image = UIImage(cgImage: imageRef , scale: UIScreen.main.scale , orientation: UIImageOrientation.up)
            
            /// 添加到数组
            images.append(image)
            
            
        }
        
        return images
        
    }
    
    /// 创建文件夹 中途只要有没有创建的文件夹都会被创建
    func creatFile(path: String) {
        
        let fileManager = FileManager.default
        
        try! fileManager.createDirectory(atPath: path,
                                         withIntermediateDirectories: true, attributes: nil)
        
    }
    
    
}






