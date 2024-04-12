//
//  ReadCollectionViewController.swift
//  FirebaseDara
//
//  Created by Sergio Rodriguez on 2024-03-27.
//

import UIKit
import FirebaseFirestore

class ReadCollectionViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var table: UITableView!
    
    // MARK: Variables
    var selectedStudent : StudentModel!
    var isFirstTime = true // to track the calling of the api only the first time in the viewDidAppear
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        self.callFirestore()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // since the call to firestore is done everytime this view appears,
        // this logic avoid to call firestore from this lifecycle the first time..
        // the component is loaded.
        if !isFirstTime {
             self.callFirestore()
        }
        self.callFirestore()
        isFirstTime = false
        self.table.reloadData()
    }
    
    // MARK: - Functions
    func callFirestore() {
        StudentProvider.getDocuments { error in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            } else {
                Toast.ok(view: self, title: "😩", message: "There was an error.")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DocumentDetailsViewController
        if segue.identifier == "fromCollectionToDocument" {
            dest.student = self.selectedStudent
            dest.delegate = self
        }
    }
}

// MARK: - Extensions
extension ReadCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if StudentProvider.students.count > 0 {
            return StudentProvider.students.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if StudentProvider.students.count > 0 {
            let student = StudentProvider.students[indexPath.row]
            content.text = student.name
            content.secondaryText = student.country
            content.image = UIImage(systemName: "graduationcap.fill")
            content.imageProperties.tintColor = .systemBlue
        } else {
            content.text = "There is no students in the collection"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}

extension ReadCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if StudentProvider.students.count > 0 {
            let student = StudentProvider.students[indexPath.row]
            self.selectedStudent = student
            self.performSegue(withIdentifier: "fromCollectionToDocument", sender: self)
        }
    }
}

// This class becomes a delegate of the DocumentDetailsViewController
//  so the delegator (DocumentDetailsViewController) can delegate the task of
//  reloading the tableView when the student is updated.
extension ReadCollectionViewController: DocumentDetailsViewControllerDelegate {
    func refreshTable() {
        self.callFirestore()
        self.table.reloadData()
    }
}
