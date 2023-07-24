//
//  SecondViewController.swift
//  Assignment3
//
//  Created by user225115 on 7/23/23.
//

import UIKit

protocol SecondViewControllerDelegate: AnyObject {
    func didAddNewImage(_ imageData: Data?, _ title: String)
}




class SecondViewController: UIViewController {
    
    weak var delegate: SecondViewControllerDelegate?
    
    @IBOutlet weak var textfieldTitle: UITextField!
    @IBOutlet weak var textFieldUrl: UITextField!
    
    var imageCollection: ImageCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
            
            
    @IBAction func btnAdd(_ sender: Any) {
        // Check if both title and URL text fields have valid input
               guard let title = textfieldTitle.text, !title.isEmpty,
                     let urlString = textFieldUrl.text, !urlString.isEmpty,
                     let url = URL(string: urlString) else {
                   // Handle invalid input, e.g., show an alert
                   return
               }

               // Download the image data from the provided URL
               downloadImage(from: url) { [weak self] imageData in
                   guard let self = self else { return }

                   // Notify the delegate (ViewController) that a new image was added with the imageData and title
                   self.delegate?.didAddNewImage(imageData, title)

                   // Dismiss the SecondViewController and return to the Main VC on the main thread
                   DispatchQueue.main.async {
                       self.dismiss(animated: true, completion: nil)
                   }
               }
    }
    
            private func downloadImage(from imageURL: URL, completion: @escaping (Data?) -> Void) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        completion(imageData)
                    } else {
                        completion(nil)
                    }
                }
            }
            
            
    @IBAction func btnCancel(_ sender: Any) {// Dismiss the view controller without adding a new image
        dismiss(animated: true, completion: nil)
    }
    
        
        }
    
