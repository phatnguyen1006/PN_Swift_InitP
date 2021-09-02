//
//  ViewController.swift
//  how
//
//  Created by Phat Nguyen on 28/08/2021.
//

import UIKit
import ImageSlideshow   // A slider on the top
import SnapKit  // Use to code AutoLayout easier!!!
import Toast_Swift  // Use to create a Beautiful Toast.
import SkyFloatingLabelTextField    // Floating Label || Remember add the IQManagerKeyboard into Project ("https://github.com/hackiftekhar/IQKeyboardManager").
import NVActivityIndicatorView  // Beautiful Indicator.
import SDWebImage   // Use a Image.network to easy ... no needs to catch data or something else.
import SimpleImageViewer    // When User Tap on the Image. They can zoom or see the perfect view.

class ViewController: UIViewController {
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var viewOutSideIndicator: UIView!
    @IBOutlet weak var viewIndicator: NVActivityIndicatorView!
    @IBOutlet weak var imageNetwork: UIImageView!
    @IBOutlet weak var textField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupImgSlideShow()
        setupTextField()
        setupIndicator()
        setupUrlImage()
    }

    // setup for the Slider + Toast Swift
    func setupImgSlideShow(){
        let imgSources: [InputSource] = [
            ImageSource(image: UIImage(named: "3")!),
            ImageSource(image: UIImage(named: "1")!),
            ImageSource(image: UIImage(named: "3")!),
        ]
        imageSlideShow.setImageInputs(imgSources)
        
        // Config
        imageSlideShow.slideshowInterval = 2
        
        // ToastSwift opTap
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        imageSlideShow.addGestureRecognizer(tapGes)
    }
    
    @objc func onTapView(){
        view.makeToast("Tap into slider!!!")
    }
    // -----
    
    // setup for the textField: IQ Manager Keyboard in the AppDelegate.swift + Floating Label
    func setupTextField(){
        textField.title = "Email"
        textField.placeholder = "Enter your email"
        textField.textColor = UIColor.blue
        textField.errorColor = UIColor.red
        textField.addTarget(self, action: #selector(didTextFieldChanged(_: )), for: .editingChanged)
        
    }
    
    // Validation when onChanged
    @objc func didTextFieldChanged(_ textField: UITextField){
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (text.count < 3 || !text.contains("@")){
                    floatingLabelTextField.errorMessage = "Invalid Email"
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    // -----
    
    // Indicator
    func setupIndicator(){
        // Config Layer Z-index for 2 View: indicator = 1 | outSide auto = 0
        viewIndicator.layer.zPosition = 1
        
        // Config
        viewIndicator.backgroundColor = .clear
        viewIndicator.color = .white
        viewIndicator.type = .lineScale
        
        // Config outSide
        viewOutSideIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewOutSideIndicator.layer.cornerRadius = 10
        viewOutSideIndicator.layer.masksToBounds = true
        
        // Run
        viewIndicator.startAnimating()
    }
    // -----

    // Image.network: create url and setting to the @URL
    // SDWebImage + SimpleImageView("The lib have some bugs. Just import and fix according to the suggest of Xcode").
    func setupUrlImage(){
        let url = "https://logowik.com/content/uploads/images/swift.jpg"
        if let url = URL(string: url) {
            imageNetwork.sd_setImage(with: url, completed: nil)
        }
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(onTapImg))
        imageNetwork.isUserInteractionEnabled = true
        imageNetwork.addGestureRecognizer(tapGes)
    }
    
    // This func from the Lib. Just Copy Paste and Add @imageNetwork to the line 116.
    @objc func onTapImg(){
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageNetwork
        }

        let imageViewerController = ImageViewerController(configuration: configuration)

        present(imageViewerController, animated: true)
    }
    // -----
}

