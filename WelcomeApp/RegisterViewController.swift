import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Country: UITextField!
    @IBOutlet weak var SwitchStack: UIStackView!
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var Radio: UISegmentedControl!
    
    var firstNameErrorLabel: UILabel!
    var emailErrorLabel: UILabel!
    var termsErrorLabel: UILabel!
    var countryPicker: UIPickerView!
    let countries = ["USA", "Canada", "UK", "India", "Australia"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        // Initialize error labels
        setupErrorLabels()
        
        // Add horizontal rules (lines) below each text field
        addSeparatorBelow(textField: FirstName)
        addSeparatorBelow(textField: LastName)
        addSeparatorBelow(textField: Email)
        addSeparatorBelow(textField: Country)
        
        // Set initial placeholder colors
        setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        setPlaceholderColor(for: LastName, color: UIColor.lightGray)
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        
        // Setup country picker
        setupCountryPicker()
    }

    // Function to add a separator (horizontal rule) below the text field
    func addSeparatorBelow(textField: UITextField, color: UIColor = UIColor.lightGray) {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        
        // Add separator to the view
        self.view.addSubview(separator)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            separator.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0)
        ])
    }

    // Function to setup error labels
    func setupErrorLabels() {
        firstNameErrorLabel = createErrorLabel()
        emailErrorLabel = createErrorLabel()
        termsErrorLabel = createErrorLabel()  // New error label for the switch

        // Add labels to the view
        self.view.addSubview(firstNameErrorLabel)
        self.view.addSubview(emailErrorLabel)
        self.view.addSubview(termsErrorLabel)  // Add the terms error label
        
        // Set up constraints for the error labels
        NSLayoutConstraint.activate([
            firstNameErrorLabel.leadingAnchor.constraint(equalTo: FirstName.leadingAnchor),
            firstNameErrorLabel.topAnchor.constraint(equalTo: FirstName.bottomAnchor, constant: 2),
            
            emailErrorLabel.leadingAnchor.constraint(equalTo: Email.leadingAnchor),
            emailErrorLabel.topAnchor.constraint(equalTo: Email.bottomAnchor, constant: 2),
            
            termsErrorLabel.leadingAnchor.constraint(equalTo: SwitchStack.leadingAnchor),
            termsErrorLabel.topAnchor.constraint(equalTo: SwitchStack.bottomAnchor, constant: 2)
        ])
    }
    
    // Function to create a standardized error label
    func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }

    // Function to set placeholder color
    func setPlaceholderColor(for textField: UITextField, color: UIColor) {
        let placeholderText = textField.placeholder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }

    // Function to setup country picker for the Country text field
    func setupCountryPicker() {
        countryPicker = UIPickerView()
        countryPicker.delegate = self
        countryPicker.dataSource = self
        Country.inputView = countryPicker
        Country.delegate = self
        
        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickingCountry))
        toolbar.setItems([doneButton], animated: false)
        Country.inputAccessoryView = toolbar
    }
    
    @objc func donePickingCountry() {
        Country.resignFirstResponder() // Dismiss the picker
    }

    // UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    // UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Country.text = countries[row]
    }

    // Function to validate the form fields
    func validateForm() -> Bool {
        var isValid = true
        
        // First Name Validation
        if let firstName = FirstName.text, firstName.isEmpty {
            firstNameErrorLabel.text = "First Name is required"
            addSeparatorBelow(textField: FirstName, color: UIColor.systemRed)
            setPlaceholderColor(for: FirstName, color: UIColor.systemRed)
            isValid = false
        } else {
            firstNameErrorLabel.text = ""
            addSeparatorBelow(textField: FirstName) // Reset to default color
            setPlaceholderColor(for: FirstName, color: UIColor.lightGray) // Reset placeholder color
        }
        
        // Email Validation
        if let email = Email.text, email.isEmpty {
            emailErrorLabel.text = "Email is required"
            addSeparatorBelow(textField: Email, color: UIColor.systemRed)
            setPlaceholderColor(for: Email, color: UIColor.systemRed)
            isValid = false
        } else if let email = Email.text, !isValidEmail(email) {
            emailErrorLabel.text = "Enter a valid Email Address"
            addSeparatorBelow(textField: Email, color: UIColor.systemRed)
            setPlaceholderColor(for: Email, color: UIColor.systemRed)
            isValid = false
        } else {
            emailErrorLabel.text = ""
            addSeparatorBelow(textField: Email) // Reset to default color
            setPlaceholderColor(for: Email, color: UIColor.lightGray) // Reset placeholder color
        }


        // Switch (Terms and Conditions) Validation
        if !Switch.isOn {
            termsErrorLabel.text = "Please accept terms and conditions"
            isValid = false
        } else {
            termsErrorLabel.text = ""
        }

        return isValid
    }

    // Email validation using regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func BtnClicked(_ sender: Any) {
        if validateForm() {
            // Clear all text fields on successful registration
            FirstName.text = ""
            LastName.text = ""
            Email.text = ""
            Country.text = ""

            // Clear error labels
            firstNameErrorLabel.text = ""
            emailErrorLabel.text = ""
            termsErrorLabel.text = ""
            
            // Reset the switch and segmented control
            Switch.isOn = false
            Radio.selectedSegmentIndex = -1

            // Show success toast message
            CustomToast.showToast(message: "Registered Successfully!", inView: self.view, backgroundColor: UIColor.systemGreen)
        }
    }
}

