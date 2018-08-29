//
//  DKImagePickTool.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/25.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

protocol DKImagePickToolDelegate {
    func imagePicked(_ image:UIImage)
}

class DKImagePickTool: NSObject {

    
    var delegate:DKImagePickToolDelegate?
    // MARK: 用于弹出选择的对话框界面
    var selectorController: UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil)) // 取消按钮
        //如果是模拟器则没有拍照功能
        if !UIDevice.isSimulator() {
            controller.addAction(UIAlertAction(title: "拍照选择", style: .default) { action in
                self.selectorSourceType(type: .camera)
            })
        }
        // 拍照选择
        controller.addAction(UIAlertAction(title: "相册选择", style: .default) { action in
            self.selectorSourceType(type: .photoLibrary)
        }) // 相册选择
        return controller
    }
    
    // MARK: 轻触手势事件的回调
    func showPicker() {
        guard let controller = PDDMainViewController.instance else { return }
        controller.present(selectorController, animated: true, completion: nil)
    }
    
    func selectorSourceType(type: UIImagePickerControllerSourceType) {
        imagePickerController.sourceType = type
        // 打开图片选择器
        guard let controller = PDDMainViewController.instance else { return }
        controller.present(imagePickerController, animated: true, completion: nil)
    }
}

//MARK: 扩展图片选择和结果返回
extension DKImagePickTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: 图片选择器界面
    var imagePickerController: UIImagePickerController {
        get {
            let imagePicket = UIImagePickerController()
            imagePicket.delegate = self
            imagePicket.sourceType = .photoLibrary
            return imagePicket
        }
    }
    
    // MARK: 当图片选择器选择了一张图片之后回调
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let del = delegate else { return  }
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        del.imagePicked(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 当点击图片选择器中的取消按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // 效果一样的...
    }
}
