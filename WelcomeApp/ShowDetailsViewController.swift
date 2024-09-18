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
        let savedEmail = userDefaults.string(forKey: "email") ?? ""
        let savedGenderIndex = userDefaults.integer(forKey: "genderSelection")
        let savedCountry = userDefaults.string(forKey: "country") ?? ""
        let savedFirst = userDefaults.string(forKey: "firstName") ?? ""
        let savedLast = userDefaults.string(forKey: "lastName") ?? ""

//         Display the retrieved details in the respective text fields
        let title="Hi, "+savedFirst+" "+savedLast
        EmailShow.text = savedEmail
        CountryShow.text = savedCountry
        GenderShow.text = genders[savedGenderIndex]
        PageTitle.text = title


    }
    
    // Back button action (optional, depending on how you want to handle back navigation)
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

