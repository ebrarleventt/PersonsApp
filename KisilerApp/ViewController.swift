//
//  ViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit
import CoreData

//Her sayfadan erisilecek bir tane appDelegate olusturmak gerek, yani ben bununla veritabanina erisicem:
let appDelegate = UIApplication.shared.delegate as! AppDelegate



class ViewController: UIViewController {
    
    //Her sayafada kendisine ait olacak bir contex olusturucam, bununla veritabani islemleri yapicam:
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var kisilerTableView: UITableView!
    
    var kisilerListesi = [Kisiler]()
    
    var aramaYapiliyorMu = false
    var aramaKelimesi:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        searchBar.delegate = self
        
        //Sadece 1 kere calistigi icin viewWillAppear metodunda kullandik:
        //tumKisileriAl()
    }
    
    
    
    //Ekle ekranindan tekrar geri gelince anasayfa da yenilenmesi icin yaptik. 
    //Yoksa ekle dedikten sonra geri gelince anlık degisim olmayacakti. Cunku viewDidload 1 kez calisiyor
    override func viewWillAppear(_ animated: Bool) {
        
        
        if aramaYapiliyorMu{
            aramaYap(kisiAd: aramaKelimesi!)
        }else{
            tumKisileriAl()
        }
    
        
        //viewdidload 1 kere calistigi icin tableView metodlarini da 1 kere calistiriyor. Bununla tableView metodlarini guncelliyoruz.
        kisilerTableView.reloadData()
    }
    
    
    
    
    //Asagidaki performSeguelar bu metodu tetikledi
    //Gecis oldugunda bunu algilayabiliyoruz
    //Asagida gonderdigimiz indexPath i de alabiliriz:
    //Veri transferi:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //2 adet gecisim var guncelle ve detay bu yuzden burada kontrol etmem gerek.
        //Her geciste altta indexPath row gonderiliyor. Oncelikle bu indexOath i almam lazim:
        let index = sender as? Int
        
        if segue.identifier == "kisilerToDetay"{
            let gidilecekVC = segue.destination as! KisiDetayViewController
            gidilecekVC.kisi = kisilerListesi[index!]
        }
        
        if segue.identifier == "kisilerToGuncelle"{
            let gidilecekVC = segue.destination as! KisiGuncelleViewController
            gidilecekVC.kisi = kisilerListesi[index!]
        }
        
}
    
    
    
    
    func tumKisileriAl() {
        do{
            kisilerListesi = try context.fetch(Kisiler.fetchRequest())
        }catch{
            print("Tum kisiler alinirken hata olustu.")
        }
    }
    
    
    
    
    func aramaYap(kisiAd:String) {
        
        let fetchRequest:NSFetchRequest<Kisiler> = Kisiler.fetchRequest()
        //Tahmin ozelligi
        fetchRequest.predicate = NSPredicate(format: "kisiAd CONTAINS %@", kisiAd)
        
        do{
            
            kisilerListesi = try context.fetch(fetchRequest)
            
        }catch{
            print("Arama yapilirken hata olustu.")
        }
}
    
    
    
}




extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListesi.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Bu bir nesne artik bana kisiyi gonderecek
        let kisi = kisilerListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiCell", for: indexPath) as! KisiCellTableViewCell
        
        cell.kisiCellLabel.text = "\(kisi.kisiAd!) - \(kisi.kisiTel!)"
        
        return cell
}
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "kisilerToDetay", sender: indexPath.row)
    }
    
    
    
    //Sil ve guncelle icin:
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let silAction = UITableViewRowAction(style: .default, title: "Sil", handler: {
            //tiklanilgi zaman index bilgilerinin gelmesi lazim
            (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            //Veritabaninda silindi:
            let kisi = self.kisilerListesi[indexPath.row]
            self.context.delete(kisi)
            appDelegate.saveContext()
            
            
            if self.aramaYapiliyorMu{
                self.aramaYap(kisiAd: self.aramaKelimesi!)
            }else{
                self.tumKisileriAl()
            }
            
            
            //Arayuzde anlik gormek icin:
            self.kisilerTableView.reloadData()
             
            
    })
        
        
        let guncelleAction = UITableViewRowAction(style: .normal, title: "Guncelle", handler: {
            
            (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            self.performSegue(withIdentifier: "kisilerToGuncelle", sender: indexPath.row)
    })
        
        return [silAction, guncelleAction]
        
        }

}





extension ViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama Sonuc: \(searchText)")
        
        aramaKelimesi = searchText
        
        if searchText == ""{
            aramaYapiliyorMu = false
            tumKisileriAl()
        }else{
            aramaYapiliyorMu = true
            aramaYap(kisiAd: aramaKelimesi!)
        }
        
        kisilerTableView.reloadData()
    }
    
}
