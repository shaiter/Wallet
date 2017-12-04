//
//  TransactionTableViewController.swift
//  Wallet
//
//  Created by Артём Шайтер on 11/30/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit

class TransactionTableViewController: UITableViewController {
    
    var transactions = [Transaction]()
    
    private func loadSampleTransactions() {
        let transaction1 = Transaction(byn: 1.33, transactionCategory: "На молочко", transactionType: 0)
        let transaction2 = Transaction(byn: 0.99, transactionCategory: "На хлебушек", transactionType: 0)
        let transaction3 = Transaction(byn: 3.54, transactionCategory: "На курочку", transactionType: 0)
        transactions += [transaction1, transaction2, transaction3]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleTransactions()
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
            let newIndexPath = IndexPath(row: transactions.count, section: 0)
            transactions.append(transaction)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
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

}
