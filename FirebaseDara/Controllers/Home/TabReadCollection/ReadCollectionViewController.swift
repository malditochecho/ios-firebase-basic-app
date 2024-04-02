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
    var students : [Student] = [Student]()
    var selectedStudent : Student!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        getDataFromFirestore()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDataFromFirestore()
    }
    
    // MARK: Functions
    func getDataFromFirestore(){
        let db = Firestore.firestore()
        
        db.collection("students").addSnapshotListener( {
            ( snapshot, error) in
            if error != nil {
                Toast.ok(view: self, title: "Error", message: error?.localizedDescription ?? "Something went Wrong.")
            }
            else {
                // clean students array
                self.students = [Student]()
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        // create an empty temp student
                        let currentStudent = Student()
                        
                        // assign all the properties obtained from firestore
                        currentStudent.docId = document.documentID
                        if let name = document.get("name") as? String{
                            currentStudent.name = name
                        }
                        if let country = document.get("country") as? String {
                            currentStudent.country = country
                        }
                        if let expertise = document.get("expertise") as? String {
                            currentStudent.expertise = expertise
                        }
                        if let absences = document.get("absences") as? Int {
                            currentStudent.absences = absences
                        }
                        
                        // append the currentStudent to the students array
                        self.students.append(currentStudent)
                    }
                    self.table.reloadData() // reload table view.
                }
            }
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DocumentDetailsViewController
        if segue.identifier == "fromCollectionToDocument" {
            dest.student = self.selectedStudent
        }
    }
}

// MARK: - Extensions
extension ReadCollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.students.count > 0 {
            return self.students.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        if self.students.count > 0 {
            let student = students[indexPath.row]
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
        if self.students.count > 0 {
            let student = self.students[indexPath.row]
            self.selectedStudent = student
            self.performSegue(withIdentifier: "fromCollectionToDocument", sender: self)
        }
    }
}

