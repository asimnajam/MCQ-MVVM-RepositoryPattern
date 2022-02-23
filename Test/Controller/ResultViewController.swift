//
//  ResultViewController.swift
//  Test
//
//  Created by Admin on 22/02/2022.
//

import UIKit
import Lottie

struct ResultViewModel {
    let isPassed: Bool
}

class ResultViewController: UIViewController {
    var viewModel: ResultViewModel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = viewModel?.isPassed == true ? "Passed" : "Failed"
        let animationJSON = viewModel?.isPassed == true ? "Correct" : "wrong"
        label.text = text
        
        // Create Animation object
        let animation = Animation.named(animationJSON)
        let animationView = AnimationView(animation: animation)
        animationView.frame = imageView.bounds
        animationView.contentMode = .scaleAspectFit
        imageView.addSubview(animationView)
        animationView.play()
    }
}
