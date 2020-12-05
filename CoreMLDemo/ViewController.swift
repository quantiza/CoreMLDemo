//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Yang Long on 2020/11/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var vcs: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vcs = [VisionBasicViewController(), ClassifyingImages()]
        tableView .reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = vcs[indexPath.row]
        vc.title = String(describing: type(of: vc))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vcs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let vcType = type(of: vcs[indexPath.row])
        
        cell.textLabel?.text = String(describing: vcType)
        
        return cell;
        
    }
    
    
}
