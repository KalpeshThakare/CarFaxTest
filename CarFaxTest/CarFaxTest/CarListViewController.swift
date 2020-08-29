//
//  CarListViewController.swift
//  CarFaxTest
//
//  Created by Kalpesh Thakare on 2020-08-28.
//  Copyright © 2020 Kalpesh Thakare. All rights reserved.
//

import UIKit

class CarListViewController: UIViewController {



    //MARK: VARIABLES
    var carListings = [CarDetails]()

    //MARK: IBOUTLETS

    @IBOutlet weak var collView_CarList: UICollectionView!

    //MARK:VIEW METHODS

    override func viewDidLoad()
    {
        super.viewDidLoad()

        collView_CarList.delegate = self
        collView_CarList.dataSource = self

        overrideUserInterfaceStyle = .light

        if Network().currentReachabilityStatus == .notReachable {
           // Network Unavailable
            NSLog("Network not Available")
        } else {
           // Network Available
            self.Webservice_GetCarList()
        }
    }

    //MARK:IBACTIONS

    @IBAction func OnClick_CallDelear(_ sender: UIButton) {

        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: collView_CarList)
        let tappedIP:IndexPath = collView_CarList.indexPathForItem(at: buttonPosition)!

        let numberString:String = self.carListings[tappedIP.row].dealer.phone

        guard let number = URL(string: "tel://" + numberString) else { return }
        if UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        } else {
            let alert = UIAlertController(title: "Message", message: "Can't perform Call on Simulator", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func Webservice_GetCarList() {

        let task = URLSession.shared.dataTask(with: NSURL(string: "https://carfax-for-consumers.firebaseio.com/assignment.json")! as URL, completionHandler: { (data, response, error) -> Void in
            do{
                let CarDetails:CarClass = try JSONDecoder().decode(CarClass.self, from: data!)
                self.carListings = CarDetails.listings

                DispatchQueue.main.async {
                    self.collView_CarList.reloadData()
                }
            }
            catch {
                NSLog("json error: \(error)")
            }
        })
        task.resume()
    }
}

extension CarListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carListings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let carCell = collView_CarList.dequeueReusableCell(withReuseIdentifier: "carDetails", for: indexPath)as! CarDetailsCell

        let details:CarDetails = carListings[indexPath.row]

        if let imageDetails:ImageSizes = details.images.firstPhoto {
            self.setImage(imageView:  carCell.imgView_CarImage, fromUrl: imageDetails.large)
        } else {
            let baseUrl:String = details.images.baseUrl+"1/640x480"
            self.setImage(imageView:  carCell.imgView_CarImage, fromUrl: baseUrl)
        }

        carCell.lbl_CarInformation.text = "\(details.year) | \(details.make) | \(details.model)  \(details.trim)"
        carCell.lbl_CarPrice.text = "$ \(details.currentPrice)"
        carCell.lbl_CarMilageKm.text = "\(details.mileage) Mi"
        carCell.lbl_DelarAddress.text = "📌 \(details.dealer.address)"
        carCell.btn_delarPhoneNumber.setTitle("📞 \(details.dealer.phone)", for: .normal)

        return carCell
    }

    func setImage(imageView: UIImageView, fromUrl: String) {

        self.getData(from: NSURL(string: fromUrl)! as URL, completion: { (data, response, error) in
                       if error == nil {
                           DispatchQueue.main.async() {
                               imageView.image = UIImage(data: data ?? Data())
                           }
                       } else {
                        NSLog("Error getting Image: \(String(describing: error?.localizedDescription))")
                        }
                   })
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (collView_CarList.frame.size.width)
        let cellHeight = (collView_CarList.frame.size.height)/2.25

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
