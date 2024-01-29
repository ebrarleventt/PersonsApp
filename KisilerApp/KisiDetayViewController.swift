//
//  KisiDetayViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class KisiDetayViewController: UIViewController {
        
    @IBOutlet weak var kisiAdLabel: UILabel!
    
    @IBOutlet weak var kisiTelLabel: UILabel!
    
    var kisi:Kisiler?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let k = kisi{
            kisiAdLabel.text = k.kisiAd
            kisiTelLabel.text = k.kisiTel
        }
    }
    

}
