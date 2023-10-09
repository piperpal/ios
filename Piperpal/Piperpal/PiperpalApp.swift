//
//  PiperpalApp.swift
//  Piperpal
//
//  Created by Ole Kristian Aamot on 9/5/22.
//
import SwiftUI
import UIKit

// Define your UIKit ViewController

struct LocationResult: Codable {
    // Define the properties based on the actual JSON structure
}
import UIKit

class ViewController: UIViewController, UITextViewDelegate {

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

    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        resultTextView.delegate = self
    }
    
    // Convert HTML string to NSAttributedString
    private func attributedString(from htmlString: String) -> NSAttributedString? {
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
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(logoImageView)
        view.addSubview(searchQueryTextField)
        view.addSubview(searchButton)
        view.addSubview(resultTextView)

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

            resultTextView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            resultTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    @objc private func searchButtonTapped() {
        // Implement the logic to handle the search button tap
        guard let searchQuery = searchQueryTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // Handle invalid search query
            return
        }

        let urlString = "https://api.piperpal.com/location/json.php?service=Food&glat=60&glon=10&radius=1000&query=\(searchQuery)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    // Handle network error
                    print("Error: \(error)")
                    return
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(LocationResult.self, from: data)

                        // Assuming LocationResult is a struct or class to represent the JSON response
                        DispatchQueue.main.async {
                            self.resultTextView.text = "Received JSON response:\n\(result)"
                        }

                    } catch let decodingError {
                        // Handle JSON decoding error
                        print("Decoding Error: \(decodingError)")
                    }
                }
            }
            task.resume()
        }
    }
}

// SwiftUI App struct
@main
struct PiperpalApp: App {
    var body: some Scene {
        WindowGroup {
            // Wrap your UIKit ViewController in a UIViewControllerRepresentable
            UIKitRepresentedView()
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
