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
        
        // Set text field delegates
        FirstName.delegate = self
        Email.delegate = self
        
        // Add target for real-time validation of Switch and Segmented Control
        Switch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        Radio.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
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

    // MARK: - UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Country.text = countries[row]
    }

    // MARK: - Real-time Validation Methods

    // TextField Delegate Method for real-time validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        }
        return true
    }
    
    // TextField Did End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == FirstName {
            validateFirstName()
        } else if textField == Email {
            validateEmail()
        }
    }

    // Switch value changed (Terms and Conditions)
    @objc func switchValueChanged() {
        validateSwitch()
    }
    
    // Segment control value changed (Radio buttons)
    @objc func segmentValueChanged() {
        // Add logic for segmented control if needed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset the form and error messages
        resetForm()
    }

    
    // MARK: - Validation Functions

    func validateFirstName() {
        if let firstName = FirstName.text, firstName.isEmpty {
            firstNameErrorLabel.text = "First Name is required"
            addSeparatorBelow(textField: FirstName, color: UIColor.systemRed)
            setPlaceholderColor(for: FirstName, color: UIColor.systemRed)
        } else {
            firstNameErrorLabel.text = ""
            addSeparatorBelow(textField: FirstName) // Reset to default color
            setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        }
    }
    
    func validateEmail() {
        if let email = Email.text, email.isEmpty {
            emailErrorLabel.text = "Email is required"
            addSeparatorBelow(textField: Email, color: UIColor.systemRed)
            setPlaceholderColor(for: Email, color: UIColor.systemRed)
        } else if let email = Email.text, !isValidEmail(email) {
            emailErrorLabel.text = "Enter a valid Email Address"
            addSeparatorBelow(textField: Email, color: UIColor.systemRed)
            setPlaceholderColor(for: Email, color: UIColor.systemRed)
        } else {
            emailErrorLabel.text = ""
            addSeparatorBelow(textField: Email) // Reset to default color
            setPlaceholderColor(for: Email, color: UIColor.lightGray)
        }
    }
    
    func validateSwitch() {
        if !Switch.isOn {
            termsErrorLabel.text = "Please accept terms and conditions"
        } else {
            termsErrorLabel.text = ""
        }
    }

    // Email validation using regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func BtnClicked(_ sender: Any) {
        // Perform validation for all fields
        validateFirstName()
        validateEmail()
        validateSwitch()

        // Check if there are no validation errors before proceeding
        if firstNameErrorLabel.text?.isEmpty == true &&
           emailErrorLabel.text?.isEmpty == true &&
           termsErrorLabel.text?.isEmpty == true {
            
            // Save user details to UserDefaults
            let userDefaults = UserDefaults.standard
            userDefaults.set(FirstName.text, forKey: "FirstName")
            userDefaults.set(LastName.text, forKey: "LastName")
            userDefaults.set(Email.text, forKey: "Email")
            userDefaults.set(Country.text, forKey: "Country")
            
            // Show success toast message
            showToast(message: "Registration Successful!")
            
            // Reset the form
                   
            
            // Navigate to ShowDetailsViewController
            if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
                navigationController?.pushViewController(detailsViewController, animated: true)
            }
//            resetForm()
        }
    }
    
    // Function to show a toast message
    func showToast(message: String) {
        CustomToast.showToast(message: message, inView: self.view, backgroundColor: UIColor.systemGreen)
    }
    
    func resetForm() {
        FirstName.text = ""
        LastName.text = ""
        Email.text = ""
        Country.text = ""
        Switch.isOn = false
        Radio.selectedSegmentIndex = UISegmentedControl.noSegment
        
        // Clear error labels
        firstNameErrorLabel.text = ""
        emailErrorLabel.text = ""
        termsErrorLabel.text = ""
        
        // Reset placeholder colors
        setPlaceholderColor(for: FirstName, color: UIColor.lightGray)
        setPlaceholderColor(for: Email, color: UIColor.lightGray)
        
        // Remove separators
        addSeparatorBelow(textField: FirstName)
        addSeparatorBelow(textField: Email)
    }

    
}

