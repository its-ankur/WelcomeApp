import UIKit

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var EmailShow: UITextField!
    @IBOutlet weak var GenderShow: UITextField!
    @IBOutlet weak var CountryShow: UITextField!
    @IBOutlet weak var PageTitle: UILabel!

    let genders = ["Male", "Female", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        // Retrieve saved user details from UserDefaults
        let userDefaults = UserDefaults.standard
        let savedEmail = userDefaults.string(forKey: "Email") ?? ""
        let savedGenderIndex = userDefaults.integer(forKey: "GenderSelection")
        let savedCountry = userDefaults.string(forKey: "Country") ?? ""
        let savedFirst = userDefaults.string(forKey: "FirstName") ?? ""
        let savedLast = userDefaults.string(forKey: "LastName") ?? ""
        
        // Display the retrieved details in the respective text fields
        let title = "Hi, \(savedFirst) \(savedLast)"
        EmailShow.text = savedEmail
        CountryShow.text = savedCountry
        
        if savedGenderIndex >= 0 && savedGenderIndex < genders.count {
            GenderShow.text = genders[savedGenderIndex]
        }
        
        PageTitle.text = title
        
        // Make the text fields non-editable
        EmailShow.isEnabled = false
        GenderShow.isEnabled = false
        CountryShow.isEnabled = false
    }
    
    // Back button action
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

