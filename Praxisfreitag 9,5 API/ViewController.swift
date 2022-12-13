//
//  ViewController.swift
//  Praxisfreitag 9,5 API
//
//  Created by Michael Hornung on 13.12.22.
//

import UIKit

// MARK: Product Cell
class ProductCell: UITableViewCell {
    
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var aiLoadingImage: UIActivityIndicatorView!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBAction func btnBuy(_ sender: Any) {
        print("\n\(lblDescription.text ?? "Produkt") nicht Verfügbar\n")
    }
}

// MARK: View Controller
class ViewController: UIViewController {
    
    @IBOutlet weak var aiLoadingProducts: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let apiClient = APIClient()
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        aiLoadingProducts.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        apiClient.downloadProductInfo{ response in
            
            self.products = response.products

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.aiLoadingProducts.stopAnimating()
            }
        }
    }
}

// MARK: Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return products?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
            
            cell.aiLoadingImage.startAnimating()
            
            guard let product = products?[indexPath.row] else {return cell}
            
            cell.lblDescription.text = product.description
            cell.lblPrice.text = product.price
            
            self.apiClient.downloadImage(imageUrl: URL(string: product.imageURL)!){ image in
                DispatchQueue.main.async {
                    cell.ivProduct.image = image
                    cell.aiLoadingImage.stopAnimating()
                }
            }
            
            return cell
        }
    }
}

