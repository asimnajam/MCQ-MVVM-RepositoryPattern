//
//  TableViewCell.swift
//  Test
//
//  Created by Asim Najam on 2/14/22.
//

import UIKit
import Lottie

class TableViewCell: UITableViewCell {
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var answerSelectedSwitch: UISwitch!
    @IBOutlet weak var animationView: UIView!
    
    lazy var lottieAnimationView: AnimationView = {
        let animation = Animation.named("radiobutton")
        let view = AnimationView(animation: animation)
        view.frame = animationView.bounds
        view.contentMode = .scaleAspectFit
        view.stop()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.addSubview(lottieAnimationView)
    }
    
    func select() {
        lottieAnimationView.play()
    }
    
    func unselect() {
        lottieAnimationView.stop()
    }

}
