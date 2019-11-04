//
//  ImageVC.swift
//  RSSReaderArcher
//
//  Created by Artem Karpovych on 11/4/19.
//  Copyright © 2019 Artem Karpovych. All rights reserved.
//

import UIKit
import UIKit

class ImageVC: UIViewController {
    
    @IBOutlet var scaleImage: UIPinchGestureRecognizer!
    @IBOutlet weak var pinchImage: UIImageView!
    var neededImage: UIImage = UIImage()
    
    @IBAction func scaleImageAction(_ sender: UIPinchGestureRecognizer) {
        pinchImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.neededImage = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.pinchImage.image = neededImage

    }
}
