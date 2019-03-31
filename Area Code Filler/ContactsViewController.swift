//
//  ContactsViewController.swift
//  Area Code Filler
//
//  Created by Javon Davis on 12/11/18.
//  Copyright © 2018 Javon Davis. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController {
    
    struct Contact {
        var contact: CNContact
        var name: String
        var numbers: [String]
    }
    var contacts = [Contact]()
    let store = CNContactStore()
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        requestContactsAccess()
    }
    
    func setupTableView() {
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
    }
    
    func requestContactsAccess() {
        store.requestAccess(for: .contacts, completionHandler: { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.getContacts()
                }
            }
        })
    }
    
    func showAlert(title: String, message: String, okHandler: ((UIAlertAction) -> Void)? = nil, noHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okHandler))
        if let noHandler = noHandler {
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: noHandler))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkContactAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            self.getContacts()
        case .notDetermined:
            self.requestContactsAccess()
        case .denied, .restricted:
            showAlert(title: "Privacy Warning", message: "Permission was not granted for Contacts")
        }
    }
    
    func getContacts() {
        contacts = [Contact]()
        let keys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

        do {
            try store.enumerateContacts(with: request) {
                (contact, stop) in
                var phoneNumbers = [String]()
                // Array containing all unified contacts from everywhere)
                print(contact.givenName)
                for phoneNumberLabeledValue in contact.phoneNumbers {
                    let phoneNumber = phoneNumberLabeledValue.value
                    print(phoneNumber.stringValue)
                    phoneNumbers.append(phoneNumber.stringValue)
                }
                
                self.contacts.append(Contact(contact: contact, name: "\(contact.givenName) \(contact.familyName)", numbers: phoneNumbers))
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
    }
    
    func getNumbers(phoneNumber: String) -> String {
        var newNumber = ""
        for char in phoneNumber {
            if char <= "9" && char >= "0" {
                newNumber += String(char)
            }
        }
        return newNumber
    }
    
    func startsWith876(phoneNumber: String) -> Bool {
        let numbers = getNumbers(phoneNumber: phoneNumber)
        if numbers.count >= 7 {
            return numbers.starts(with: "1876") || numbers.starts(with: "876")
        }
        return false
    }
    
    func replaceWith876(phoneNumber: String) -> String {
        var newNumber = ""
        let numbers = getNumbers(phoneNumber: phoneNumber)
        if numbers.starts(with: "1") {
            newNumber += "1"
        }
        
        newNumber += "876"
        newNumber += String(numbers[numbers.index(numbers.startIndex, offsetBy: max(0, numbers.count - 7))...])
        return newNumber
    }

}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactsTableView.deselectRow(at: indexPath, animated: true)
        
        let contact = contacts[indexPath.section]
        let cnContact = contact.contact.mutableCopy() as! CNMutableContact
        let phoneNumber = contact.numbers[indexPath.row]
        
        print("Clicked \(phoneNumber)")
        if !startsWith876(phoneNumber: phoneNumber) {
            let currentLabel = cnContact.phoneNumbers[indexPath.row].label
            let newNumber = CNPhoneNumber(stringValue: replaceWith876(phoneNumber: phoneNumber))
            showAlert(title: "Change number?", message: "Would you like to change \(phoneNumber) to \(newNumber.stringValue)?", okHandler: { _ in
                cnContact.phoneNumbers[indexPath.row] = CNLabeledValue(label: currentLabel, value: newNumber)
                
                let saveRequest = CNSaveRequest()
                saveRequest.update(cnContact)
                do {
                    try self.store.execute(saveRequest)
                    print("success")
                    self.getContacts()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
                ,
                      noHandler: { _ in
                        print("Dismissed")
                        
            })
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts[section].numbers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let contact = contacts[section]
        return contact.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactNameCell") as? ContactTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactViewCell")
        }
        let contact = contacts[indexPath.section]
        cell.contactNameLabel.text = contact.numbers[indexPath.row]
        return cell
    }
    
    
}

