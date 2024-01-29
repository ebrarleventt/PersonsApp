//
//  KisiGuncelleViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class KisiGuncelleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var kisi:Kisiler?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let k = kisi{
            kisiAdTextField.text = k.kisiAd
            kisiTelTextField.text = k.kisiTel
        }
}
    
    
    @IBAction func guncelle(_ sender: Any) {
        if let k = kisi, let ad = kisiAdTextField.text, let tel = kisiTelTextField.text{
            k.kisiAd = ad
            k.kisiTel = tel
            appDelegate.saveContext()
        }
    }
}
