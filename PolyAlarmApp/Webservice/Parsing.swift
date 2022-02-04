//
//  Parsing.swift
//  PolyAlarmApp
//
//  Created by deanny on 09.05.2021.
//

import SwiftSoup
import Foundation
import Firebase

/*struct Faculty {
    var webFaculty, httpFaculty: String;
}*/

/*let first = Faculty(webFaculty: ".1wg585fewow.0.2.2.0.", httpFaculty: "122")
let second = Faculty(webFaculty: ".1fj4xurrq4g.0.2.2.0.", httpFaculty: "101")
let third = Faculty(webFaculty: ".1o0sk5gsruo.0.2.2.0.", httpFaculty: "119")
let fourth = Faculty(webFaculty: ".acfe0qz5ds.0.2.2.0.", httpFaculty: "99")
let fifth = Faculty(webFaculty: ".1jmqii98oow.0.2.2.0.", httpFaculty: "94")
let sixth = Faculty(webFaculty: ".12sqkk1m7eo.0.2.2.0.", httpFaculty: "98")
let seventh = Faculty(webFaculty: ".7jxnjqgk5c.0.2.2.0.", httpFaculty: "95")
let eigth = Faculty(webFaculty: ".1wqybhr44qo.0.2.2.0.", httpFaculty: "92")
let ninth = Faculty(webFaculty: ".uhylhsrnk0.0.2.2.0.", httpFaculty: "93")
let tenth = Faculty(webFaculty: ".myuwp16tj4.0.2.2.0.", httpFaculty: "100")*/

var faculties: Dictionary<String, String> = [ "48": "122",
                                               "38": "101",
                                               "47": "119",
                                               "36": "99",
                                               "33": "94",
                                               "34": "98",
                                               "35": "95",
                                               "31": "92",
                                               "32": "93",
                                               "37": "100" ]

private let db = Firestore.firestore()

var userPhone = ""
func gettingPhoneNumber() {
    let user = Auth.auth().currentUser
    if let user = user {
        userPhone = user.phoneNumber!
    }
    userPhone.removeFirst(2)
}

var groupNumber = ""
func gettingGroupNumber() {
    gettingPhoneNumber()
    let docRef = db.collection("users").document(userPhone)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data()
            groupNumber = dataDescription!["groupNumber"] as! String
        } else {
            print("Document does not exist")
        }
    }
}

func gettingURL() {
    gettingGroupNumber()
    let facultyFromGroup = groupNumber.prefix(2)
    let groupURL = faculties[String(facultyFromGroup)]!
    let facultyURL = "https://ruz.spbstu.ru/faculty/\(String(describing: groupURL))/groups"
    let url = URL(string: facultyURL)
    let request = NSMutableURLRequest(url: url!)
    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil {
            print(error!)
        } else {
            if let unrappedData = data {
                let dataString = NSString(data: unrappedData, encoding: String.Encoding.utf8.rawValue)
                print(dataString!)
                // prefix = ".7jxnjqgk5c.0.2.2.0."
                //let postfix =
                //let range = NSMakeRange(<#T##loc: Int##Int#>, <#T##len: Int##Int#>)
                //let href = dataString?.substring(with: <#T##NSRange#>)
            }
        }
    }
    task.resume()
}

/*func Parsing() {
    let myURLString = "https://ruz.spbstu.ru"
    guard let myURL = URL(string: myURLString) else { return }
    
    do {
        let myHTMLString = try! String(contentsOf: myURL, encoding: .utf8)
        let htmlContent = myHTMLString
        
        do {
            let doc = try SwiftSoup.parse(htmlContent)
            do {
                let element = try doc.select("").array()
                do {
                    let text = try element[7].text()
                    print(text)
                }
            } catch {
                
            }
        } catch let error {
            print("Error \(error)")
        }
    }
}*/
