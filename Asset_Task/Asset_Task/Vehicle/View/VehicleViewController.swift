//
//  VehicleViewController.swift
//  Asset_Task
//
//  Created by Kishore Shetty on 01/12/21.
//

import UIKit
import iOSDropDown

class VehicleViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var vehicleMakeDropDown: DropDown!
    @IBOutlet weak var manufactureYearDropDown: DropDown!
    @IBOutlet weak var fuelTypeDropDown: DropDown!
    @IBOutlet weak var capacityDropDown: DropDown!
    @IBOutlet weak var qrTF: UITextField!
    @IBOutlet weak var expandCollView: UICollectionView!
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var isDataLoaded: Bool = false
    var vehicle = VehicleViewModel()
    var vehicleTyes = [String]()
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getVehicleDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.expandCollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.expandCollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if object is UICollectionView{
                if let newValue = change?[.newKey]{
                    let newSize = newValue as? CGSize
                    self.collHeight.constant = newSize?.height ?? 0
                }
            }
        }
    }
    
    // MARK: - Functionality
    func nibRegister(){
        let nib = UINib(nibName: "VehicleCollectionViewCell", bundle: nil)
        expandCollView.register(nib, forCellWithReuseIdentifier: "VehicleCollectionViewCell")
    }
    
    // MARK: - API Functionality
    func getVehicleDetails(){
        vehicle.getVehicleDetails { vehicle, error in
            guard error == nil, let vehicle = vehicle else{
                print(error!.description)
                return
            }
            print(vehicle)
            if let vehicle_type = vehicle.vehicle_type{
                self.vehicleTyes = vehicle_type.compactMap({$0.text})
                self.vehicleTyes.insert("More", at: 3)
                DispatchQueue.main.async {
                    self.expandCollView.reloadData()
                }
            }
            if let makes = vehicle.vehicle_make{
                self.vehicleMakeDropDown.optionArray = makes.compactMap({$0.text})
            }
            if let manufactures = vehicle.manufacture_year{
                self.manufactureYearDropDown.optionArray = manufactures.compactMap({$0.text})
            }
            if let fuels = vehicle.fuel_type{
                self.fuelTypeDropDown.optionArray = fuels.compactMap({$0.text})
            }
            if let capacities = vehicle.vehicle_capacity{
                self.capacityDropDown.optionArray = capacities.compactMap({$0.text})
            }
            
        }
    }
    
    
    // MARK: - Actions
    @IBAction func qrScannerBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Extensions and Delegates
extension VehicleViewController: QRCodebackDelegate{
    func qrCodeBackTo(vehicle qrCode: String) {
        qrTF.text = qrCode
    }
}

extension VehicleViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleTyes.isEmpty ? 0 : (isDataLoaded ? vehicleTyes.count : 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.expandCollView.dequeueReusableCell(withReuseIdentifier: "VehicleCollectionViewCell", for: indexPath) as! VehicleCollectionViewCell
        
            if indexPath.item == 3{
                cell.img.image = #imageLiteral(resourceName: "plus")
                
            }else{
                cell.img.image = #imageLiteral(resourceName: "truck")
            }
            cell.lbl.text = vehicleTyes[indexPath.row]
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3{
            self.isDataLoaded = self.isDataLoaded ? false : true
            self.expandCollView.reloadData()
        }
    }
    
}
extension VehicleViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 4
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: 72)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

