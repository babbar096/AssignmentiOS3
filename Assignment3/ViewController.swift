//
//  ViewController.swift
//  Assignment3
//
//  Created by user225115 on 7/23/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SecondViewControllerDelegate, ImageCollectionDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    var imageCollection = ImageCollection() // Initialize the ImageCollection
    let placeholderImage = UIImage(named: "placeholder") // Placeholder image in assets folder

   
    override func viewDidLoad() {
         super.viewDidLoad()
        imageCollection = ImageCollection()
         imageCollection.delegate = self
     }

    // Implement the delegate method to reload the picker view data when a new image is added
    func didUpdateImageCollection() {
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload the picker view data every time the view appears to reflect any changes
        pickerView.reloadAllComponents()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return imageCollection.numberOfImages()
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           // Get the image title for the current row in the picker view
           return imageCollection.image(at: row)?.title
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           // When the user selects an image title in the picker, update the image view with the corresponding image
           if let image = imageCollection.image(at: row) {
               downloadImageAndUpdateUI(from: image.url)
           }
       }

 
    
    
    
    func didAddNewImage() {
            DispatchQueue.main.async {
                // Reload the picker view data to display the new image title
                self.pickerView.reloadAllComponents()

                // Select the last row (newly added image) in the picker view
                let lastIndex = self.imageCollection.numberOfImages() - 1
                self.pickerView.selectRow(lastIndex, inComponent: 0, animated: true)

                // Update the image view with the newly added image
                if let image = self.imageCollection.image(at: lastIndex) {
                    self.downloadImageAndUpdateUI(from: image.url)
                }
            }
        }
    

    func didAddNewImage(_ imageData: Data?, _ title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.imageView.image = image
            } else {
                self.imageView.image = self.placeholderImage
            }

            // Create a new Image object with the newly received title and imageURL
            if let imageURL = URL(string: title) {
                let newImage = Image(title: title, url: imageURL)

                // Add the newly created Image object to the image collection
                self.imageCollection.addImage(newImage)
            }

            // Reload the picker view data to display the new image title
            self.pickerView.reloadAllComponents()

            // Select the last row (newly added image) in the picker view
            let lastIndex = self.imageCollection.numberOfImages() - 1
            self.pickerView.selectRow(lastIndex, inComponent: 0, animated: true)
        }
    }

    
    // Method to download the image data from the provided URL and update the image view
    private func downloadImageAndUpdateUI(from imageURL: URL) {
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self.imageView.image = self.placeholderImage
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = self.placeholderImage
                }
            }
        }

        task.resume()
    }
    @IBAction func addButtonTapped(_ sender: Any) {
            if let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
                // Set the delegate and imageCollection properties before presenting the SecondViewController
                secondVC.delegate = self
                secondVC.imageCollection = imageCollection
                
                // Additional print statements for debugging
                print("Presenting SecondViewController")
                present(secondVC, animated: true, completion: nil)
            }
    }
    
}
