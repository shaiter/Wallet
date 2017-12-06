//
//  TransactionTableViewController.swift
//  Wallet
//
//  Created by Артём Шайтер on 11/30/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit
import os.log

class TransactionTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var transactions = [Transaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedTransactions = loadTransactions() {
            transactions += savedTransactions
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let transaction = transactions[indexPath.row]
        cell.byn.text = String(transaction.byn)
        cell.usd.text = String(transaction.usd)
        cell.eur.text = String(transaction.eur)
        cell.rub.text = String(transaction.rub)
        cell.date.text = String(transaction.date)
        cell.transactionCategory.text = transaction.transactionCategory
        return cell
    }
    
    @IBAction func unwindToTransactionsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TransactionViewController, let transaction = sourceViewController.transaction {
            //let newIndexPath = IndexPath(row: transactions.count, section: 0)
            //transactions.append(transaction)
            let newIndexPath = IndexPath(row: 0, section: 0)
            transactions.insert(transaction, at: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            saveTransactions()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func saveTransactions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(transactions, toFile: Transaction.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Transactions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save transactions...", log: OSLog.default, type: .error)
        }
    }
    private func loadTransactions() -> [Transaction]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Transaction.ArchiveURL.path) as? [Transaction]
    }
}
