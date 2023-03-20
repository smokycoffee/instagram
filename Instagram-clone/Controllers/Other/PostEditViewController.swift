//
//  PostEditViewController.swift
//  Instagram-clone
//
//  Created by Tsenguun on 20/3/23.
//

import UIKit
import SnapKit
import CoreImage

class PostEditViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        title = "Edit"
        imageView.image = image
        view.addSubview(imageView)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: { // dummy to test
            self.filterImage(image: self.image)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.width.height.equalTo(view.width)
        }
    }

    private func filterImage(image: UIImage) {
        guard let cgImage = image.cgImage else {return}
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(CIImage(cgImage: cgImage), forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filter?.outputImage else {return}
        
        let context = CIContext()
        
        if let outputcgImage =  context.createCGImage(outputImage, from: outputImage.extent) {
            let filteredImage = UIImage(cgImage: outputcgImage)
            
            imageView.image = filteredImage
        }
    }

}
