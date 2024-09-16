import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        // Add horizontal rules (lines) below each text field
        addSeparatorBelow(textField: FirstName)
        addSeparatorBelow(textField: LastName)
        addSeparatorBelow(textField: Email)
    }

    // Function to add a separator (horizontal rule) below the text field
    func addSeparatorBelow(textField: UITextField) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        
        // Add separator to the view
        self.view.addSubview(separator)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            separator.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5)
        ])
    }
    
    @IBAction func BtnClicked(_ sender: Any) {
        // Clear all text fields
        FirstName.text = ""
        LastName.text = ""
        Email.text = ""
        
        // Show a pop-up for successful registration
        let alertController = UIAlertController(title: "Success", message: "Registered Successfully!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}

