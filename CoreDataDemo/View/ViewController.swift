//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by SHRIDEVI SAWANT on 07/02/22.
//  Copyright © 2022 comviva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let empVM = EmpViewModel() // strong reference of View Model
    
    @IBOutlet weak var tbl : UITableView!
    
    var isFiltering = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Sandbox dir: \(NSHomeDirectory())")
        
        empVM.fetchData()
        
        tbl.dataSource = self
        tbl.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addClicked))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteClicked))
        
    }

    @objc func deleteClicked(){
        isFiltering = false
        empVM.deleteAllEmp()
       
        tbl.reloadData()
    }
    
    @objc func addClicked(){
        isFiltering = false
        let alertVC = UIAlertController(title: "New Employee", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { (tf) in
            tf.placeholder = "Enter Name"
            
        }
        
        alertVC.addTextField { (tf) in
            tf.placeholder = "Enter Emp ID"
            
        }
        alertVC.addTextField { (tf) in
            tf.placeholder = "Enter Salary"
            
        }
        alertVC.addTextField { (tf) in
            tf.placeholder = "Enter City"
            
        }
        
        let addEmpAction = UIAlertAction(title: "ADD", style: .default) { _ in
            
            let name = alertVC.textFields?[0].text ?? ""
            let id = alertVC.textFields?[1].text ?? ""
            let salary = alertVC.textFields?[2].text ?? ""
            let city = alertVC.textFields?[3].text ?? ""
            
            if !name.isEmpty && !id.isEmpty && !salary.isEmpty && !city.isEmpty {
                
                if let empID = Int(id), let sal = Int(salary) {
                    
                    self.empVM.addEmp(empName: name, empId: empID, empSal: sal, empCity: city)
                    
                    self.tbl.reloadData()
                }
                else {
                    print("ID and salary : only digits..")
                }
            }
            else {
                print("All fields data not entered..")
            }
        }
        
        alertVC.addAction(addEmpAction)
        present(alertVC, animated: false, completion: nil)
        
        
    }
    
    @IBAction func sortData(_ sender: Any) {
        //empList = getEmpSortByName()
        isFiltering = false
        empVM.sortByName()
        tbl.reloadData()
    }
    
    @IBAction func filterData(_ sender: Any) {
        isFiltering = true
        empVM.filterByCity(empCity: "Bangalore")
        tbl.reloadData()
    }
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? empVM.filteredList.count : empVM.empList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "empCell", for: indexPath) as? EmployeeCell)!
        
        var emp = empVM.empList[indexPath.row]
        if isFiltering {
            emp = empVM.filteredList[indexPath.row]
        }
        cell.nameL.text = emp.empName
        cell.emp_idL.text = "\(emp.emp_id)"
        cell.cityL.text = emp.city
        cell.salaryL.text = "\(emp.salary)"
        
        return cell
    }
    
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFiltering{
            empVM.deleteEmp(idx: indexPath.row)
            tbl.reloadData()
        }
    }
    
}
