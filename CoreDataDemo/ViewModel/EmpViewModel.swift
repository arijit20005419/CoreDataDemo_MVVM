//
//  EmpViewModel.swift
//  CoreDataDemo
//
//  Created by SHRIDEVI SAWANT on 15/02/22.
//  Copyright © 2022 comviva. All rights reserved.
//

import Foundation

class EmpViewModel {
    
    let empModel = EmpModel() // strong reference to model
    
    var empList : [Employee] = []
    var filteredList : [Employee] = []
    
    func fetchData() {
        empList = empModel.getEmployees()
    }
    
    func addEmp(empName: String, empId: Int, empSal: Int, empCity: String){
        if let emp = empModel.addEmployee(name: empName, id: empId, salary: empSal, city: empCity) {
            
            empList.append(emp)
        }
    }
    
    func deleteEmp(idx: Int){
        let emp = empList[idx]
        if empModel.deleteEmp(empToDelete: emp) {
            empList.remove(at: idx)
        }
    }
    
    func deleteAllEmp(){
        
        if empModel.deleteAllEmp() {
            empList.removeAll()
        }
    }
    
    func sortByName(){
        
        empList = empModel.getEmpSortByName()
    }
    
    func filterByCity(empCity: String){
        filteredList = empModel.getEmpFilterByCity(cityName: empCity)
    }
}
