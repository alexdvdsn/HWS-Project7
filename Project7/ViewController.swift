//
//  ViewController.swift
//  Project7
//
//  Created by Alex Davidson on 2/8/21.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Challenge 1: add a credits UIBarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsButton))
        
        //
        
        //MARK: Challenge 2: add filter button to filter results using a string
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle") , style: .plain, target: self, action: #selector(filterPetitionText))
        
        //
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    //MARK: - Challenge 1 continued
    @objc func creditsButton() {
        let ac = UIAlertController(title: "Credits", message: "This data comes from We The People API of the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    //
    
    //MARK: - Challenge 2 continued
    @objc func filterPetitionText() {
        let ac = UIAlertController(title: "FIlter Results", message: "Enter a value to narrow results", preferredStyle: .alert)
        ac.addTextField()
        
        //pass the text value into the filterArray Method when filter button is pressed
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [unowned self, ac] (action) in
            if let filteredText = ac.textFields![0].text {
                filterArray(stringValue: filteredText)
                tableView.reloadData()
            }
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //return to the displayed information to the original data from JSON when action is cancelled.
            //In the future, add a "clear filter" button for better user interaction
            self.filteredPetitions = self.petitions
            self.tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    func filterArray(stringValue: String) {
        var tempArray = [Petition]()
        
        //for each item in untouched array, append to filtered array if it matches conditons
        for item in filteredPetitions {
            if item.title.contains(stringValue) || item.body.contains(stringValue) {
                //if true, append to temp array
                tempArray.append(item)
            }
        }
        //set the displayed array to the temp array
        filteredPetitions = tempArray
        
            }
    
    //
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            filteredPetitions = jsonPetitions.results
            petitions = filteredPetitions

            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //load data from filteredArray
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

