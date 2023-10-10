//
//  ViewController.swift
//  Project7
//
//  Created by Yulian Gyuroff on 1.10.23.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    //Data fetched OK
                    //print("data.count=\(data.count)")
                    self?.parse(json: data)
                    return
                }
            }
            self?.showError()
        }
      
     }
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; Check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }

    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
//            print("petitions.count=\(petitions.count)")
//            for item in petitions{
//                print("TITLE \(item.title)","BODY \(item.body)")
//            }
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.isEmpty{
            return petitions.count
        }else{
            return filteredPetitions.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if filteredPetitions.isEmpty{
            let petition = petitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }else{
            let petition = filteredPetitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if filteredPetitions.isEmpty {
            vc.detailItem = petitions[indexPath.row]
        }else{
            vc.detailItem = filteredPetitions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func showCredit(){
        let ac = UIAlertController(title: "Credit", message: "The data comes from the\n\"We The People API\"\nof the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Search:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            guard let searchText = ac?.textFields?[0].text else { return }
            self?.submit(searchText)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ searchText: String){
        
        filteredPetitions.removeAll(keepingCapacity: true)
        
        DispatchQueue.global(qos:   .userInitiated).async {
            [weak self] in
            guard let tempPetitions = self?.petitions else { return }
            for item in tempPetitions  {
                if item.title.contains(searchText) || item.body.contains(searchText){
                    self?.filteredPetitions.append(item)
                }
            }
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
            
        }
        
    }
}

