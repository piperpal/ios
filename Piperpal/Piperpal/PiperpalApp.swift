//
//  PiperpalApp.swift
//  Piperpal
//
//  Created by Ole Kristian Aamot on 9/5/22.
//
import UIKit
import WebKit
import CoreLocation
import SwiftUI

// Define your UIKit ViewController

struct LocationResult: Codable {
    // Define the properties based on the actual JSON structure
}

class ViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, WKNavigationDelegate {
    
    let latitude = 60
    let longitude = 10
    let locationManager = CLLocationManager()
    let webView = WKWebView()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo") // Replace "your_logo" with the actual name of your logo image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchQueryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location Search Query"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func searchButtonTapped() {
        // Load the WKWebView with the desired URL
        let searchQuery = self.searchQueryTextField.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let urlString = "https://www.piperpal.com/?glat=\(latitude)&glon=\(longitude)&radius=1000&query=\(String(describing: searchQuery))"
        // Replace with your desired URL
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        let searchButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Search", for: .normal)
            button.addTarget(ViewController.self, action: #selector(searchButtonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let resultTextView: UITextView = {
            let textView = UITextView()
            textView.isEditable = false
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        }()
        
        func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            resultTextView.delegate = self
            setupLocationManager()
        }
        
       func setupLocationManager() {
           // locationManager.delegate = self
           // locationManager.requestWhenInUseAuthorization()
           // locationManager.startUpdatingLocation()
       }
        
        // CLLocationManagerDelegate method to handle location updates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Use latitude and longitude in your API request or other logic
            print("Current Location: \(latitude), \(longitude)")
        }
        
        // Convert HTML string to NSAttributedString
        func attributedString(from htmlString: String) -> NSAttributedString? {
            do {
                let data = htmlString.data(using: .utf8)!
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                return try NSAttributedString(data: data, options: options, documentAttributes: nil)
            } catch {
                print("Error creating attributed string from HTML: \(error)")
                return nil
            }
        }
        
        // UITextViewDelegate method to handle clickable links
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
            return false
        }
        
        func setupUI() {
            view.backgroundColor = .white
            
            view.addSubview(logoImageView)
            view.addSubview(searchQueryTextField)
            view.addSubview(searchButton)
            view.addSubview(resultTextView)
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.widthAnchor.constraint(equalToConstant: 240),
                logoImageView.heightAnchor.constraint(equalToConstant: 180),
                
                searchQueryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
                searchQueryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                searchQueryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                searchButton.topAnchor.constraint(equalTo: searchQueryTextField.bottomAnchor, constant: 20),
                searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            webView.navigationDelegate = self
        }
        
        // SwiftUI App struct
        @main
        struct PiperpalApp: App {
            var body: some Scene {
                WindowGroup {
                    // Wrap your UIKit ViewController in a UIViewControllerRepresentable
                    UIKitRepresentedView()
                    // Implement the logic to handle the search button tap
                }
            }
        }
        
        // SwiftUI View that represents the UIKit ViewController
        struct UIKitRepresentedView: UIViewControllerRepresentable {
            func makeUIViewController(context: Context) -> UIViewController {
                let viewController = ViewController()
                viewController.viewDidLoad()
                return viewController
            }
            
            func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
                // Update the view controller if needed
            }
        }
        
        // Entry point for UIKit-based app
        //UIApplicationMain(
        //  CommandLine.argc,
        //  CommandLine.unsafeArgv,
        //  nil,
        //  NSStringFromClass(AppDelegate.self)
        // )
    }
}

