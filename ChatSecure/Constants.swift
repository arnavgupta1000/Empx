struct K {
    static let appName = "ChatSecure"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let userIDField = "userID"
        static let chatRoomIDField = "chatRoomID"
        static let employeeCollectionName = "employees"
        static let nameField = "name"
        static let phoneField = "phone"
        static let empIDField = "empID"
        static let salaryField = "salary"
        static let addressField = "address"
                static let designationField = "designation"
    }
    
    struct Cell {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
    }
}
