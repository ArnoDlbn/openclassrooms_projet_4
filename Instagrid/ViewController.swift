//
//  ViewController.swift
//  Instagrid
//
//  Created by Arnaud Dalbin on 24/04/2019.
//  Copyright © 2019 Arnaud Dalbin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    // All objects of the view
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var grid: UIStackView!
    @IBOutlet weak var buttonGrid1: UIButton!
    @IBOutlet weak var buttonGrid2: UIButton!
    @IBOutlet weak var buttonGrid3: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var buttons: UIStackView!
    @IBOutlet weak var rectangle: UIView!
    @IBOutlet var gestureOrientation: UISwipeGestureRecognizer!
    
    var imagePicker = UIImagePickerController()
    var selectedButton: UIButton!
    
    // Reset the selected buttonGrid
    func resetGridButtonState() {
        buttonGrid1.isSelected = false
        buttonGrid2.isSelected = false
        buttonGrid3.isSelected = false
    }
    
    // Showing selected grids
    @IBAction func showGrid1(_ sender: UIButton) {
        resetGridButtonState()
        sender.isSelected = true
        sender.imageView?.contentMode = .scaleAspectFill
        chooseLabel.isHidden = true
        grid.isHidden = false
        button2.isHidden = true
        button4.isHidden = false
    }
    
    @IBAction func showGrid2(_ sender: UIButton) {
        resetGridButtonState()
        sender.isSelected = true
        chooseLabel.isHidden = true
        grid.isHidden = false
        button2.isHidden = false
        button4.isHidden = false
    }
    
    @IBAction func showGrid3(_ sender: UIButton) {
        resetGridButtonState()
        sender.isSelected = true
        chooseLabel.isHidden = true
        grid.isHidden = false
        button4.isHidden = true
        button2.isHidden = false
    }
    
    // Put selected image on button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        selectedButton.setImage(imagePicked, for: .normal)
        button1.imageView?.contentMode = .scaleAspectFill
        button3.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    // Allow to choose and edit selected image from library
    @IBAction func chooseImage(_ sender: UIButton) {
        selectedButton = sender
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Animates the swipe according to the orientation
    func animateSwipe() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            UIView.animate(withDuration: 0.2, animations: {
                self.rectangle.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.rectangle.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            })
        }
    }
    
    // Transforms grid into image to share
    func createPicture() {
        let renderer = UIGraphicsImageRenderer(size: rectangle!.bounds.size)
        let capturedImage = renderer.image {
            (ctx) in
            rectangle!.drawHierarchy(in: rectangle!.bounds, afterScreenUpdates: true)
        }
        let activityController = UIActivityViewController (activityItems: [capturedImage], applicationActivities: nil)
        present(activityController, animated: true)
        activityController.completionWithItemsHandler = { _ , _ , _, _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.rectangle.transform = .identity
            })
        }
    }
    
    // Allow to share the grid
    @IBAction func shareUp(_ sender: UISwipeGestureRecognizer) {
        animateSwipe()
        createPicture()
    }
    
    // Do any additional setup after loading the view
    override func viewDidLoad() {
        super.viewDidLoad()
        grid.isHidden = true
        chooseLabel.isHidden = false
        imagePicker.delegate = self
    }
    
    // Do any additional setup when orientation device changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            swipeLabel.text = "Swipe up to share !"
            arrow.transform = CGAffineTransform.identity
            gestureOrientation.direction = .up
        } else {
            swipeLabel.text = "Swipe left to share !"
            arrow.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi / 2))
            gestureOrientation.direction = .left
        }
    }
    
}

