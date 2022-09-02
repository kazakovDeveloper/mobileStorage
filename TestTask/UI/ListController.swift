//
//  ListController.swift
//  TestTask
//
//  Created by Kazakov Danil on 02.09.2022.
//

import UIKit

class ListController: UITableViewController {

    var primaryStorage = PrimaryStorage()
    func loadDatabase() {
        print("Load database")

        mobiles = primaryStorage.getAll().sorted{ $0.imei > $1.imei }
    }
    var mobiles: [Mobile] = []
    
    /*
    {
        /*
        primaryStorage.getAll().sorted { mobile1, mobile2 in
            if mobile1.imei > mobile2.imei {
                return true
            } else {
                return false
            }
        }
        */
        print("Load database")
        return
    }
    */
    
    @IBAction func addMobileAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Add mobile", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "IMEI"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Model"
        }

        
        let actionAdd = UIAlertAction(title: "Add", style: .default) { action in
            if let imei = alertController.textFields![0].text,
               let model = alertController.textFields![1].text,
               imei != "",
               model != ""
            {
                do {
                    _ = try self.primaryStorage.save(mobile: Mobile(imei: imei, name: model))
                    self.loadDatabase()
                    self.tableView.reloadData()
                } catch PrimaryStorage.ErrorStorage.ErrorIMEIExists {
                    self.showMessage(text: "IMEI \(imei) is allready exists")
                } catch {
                    self.showMessage(text: "Unknown error: \(error.localizedDescription)")
                }
                
            }

        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true)
        
        /*
        try? primaryStorage.save(mobile: Mobile(imei: UUID().uuidString, name: "Super mobile"))
        self.tableView.reloadData()
         */
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDatabase()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mobiles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let mobileForCell = mobiles[indexPath.row]
        
        cell.textLabel?.text = mobileForCell.name
        cell.detailTextLabel?.text = mobileForCell.imei

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mobileForCell = mobiles[indexPath.row]
            try? primaryStorage.delete(mobileForCell)
            loadDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showMessage(text: String) {
        let alertController = UIAlertController(title: "Message", message: text, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(actionOK)
        present(alertController, animated: true)
    }

}
