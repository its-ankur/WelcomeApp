import FMDB

class DatabaseHelper {
    static let shared = DatabaseHelper()
    private var db: FMDatabase?

    private init() {
        openDatabase()
        createTable()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UsersDatas.sqlite")

        db = FMDatabase(path: fileURL.path)

        if db?.open() == true {
            print("Database opened successfully")
        } else {
            print("Failed to open database")
        }
    }

    private func createTable() {
        let createTableSQL = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT NOT NULL,
            lastName TEXT,          -- Optional
            email TEXT NOT NULL UNIQUE,
            country TEXT,           -- Optional
            gender TEXT,            -- Optional
            termsAccepted INTEGER NOT NULL
        )
        """
        do {
            try db?.executeUpdate(createTableSQL, values: nil)
            print("Table created successfully")
        } catch {
            print("Failed to create table: \(error.localizedDescription)")
        }
    }

    func insertUser(firstName: String, lastName: String?, email: String, country: String?, gender: String?, termsAccepted: Bool) {
        let insertSQL = "INSERT INTO Users (firstName, lastName, email, country, gender, termsAccepted) VALUES (?, ?, ?, ?, ?, ?)"
        do {
            try db?.executeUpdate(insertSQL, values: [
                firstName,
                lastName ?? NSNull(),  // Use NSNull if value is nil
                email,
                country ?? NSNull(),
                gender ?? NSNull(),
                termsAccepted ? 1 : 0
            ])
            print("User inserted successfully")
        } catch {
            print("Failed to insert user: \(error.localizedDescription)")
        }
    }

    func getUser(email: String) -> (firstName: String, lastName: String?, country: String?, gender: String?, termsAccepted: Bool)? {
        let querySQL = "SELECT firstName, lastName, country, gender, termsAccepted FROM Users WHERE email = ?"
        do {
            let result = try db?.executeQuery(querySQL, values: [email])
            if result?.next() == true {
                let firstName = result?.string(forColumn: "firstName") ?? ""
                let lastName = result?.string(forColumn: "lastName")  // Optional
                let country = result?.string(forColumn: "country")    // Optional
                let gender = result?.string(forColumn: "gender")      // Optional
                let termsAccepted = result?.int(forColumn: "termsAccepted") != 0
                return (firstName, lastName, country, gender, termsAccepted)
            } else {
                print("No user found with this email")
                return nil
            }
        } catch {
            print("Failed to retrieve user: \(error.localizedDescription)")
            return nil
        }
    }
}

