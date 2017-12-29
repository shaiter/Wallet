//
//  AllTransactionsViewController.swift
//  Wallet
//
//  Created by Артём Шайтер on 12/7/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit
import os.log

class AllTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate {

    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var filterSegmentController: UISegmentedControl!
    @IBOutlet weak var sortSegmentController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var transactions = [Transaction]()
    
    var filteredTransactions = [Transaction]()
    
    @IBAction func filterTransactions(_ sender: Any) {
        filter()
        self.updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedTransactions = loadTransactions() {
            transactions += savedTransactions
        }
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        searchBar.delegate = self
        filteredTransactions = transactions
        self.updateData()
    }
    
    func filter() {
        switch filterSegmentController.selectedSegmentIndex {
        case 0:
            filteredTransactions = transactions
        case 1:
            filteredTransactions = transactions.filter{$0.transactionType == 0}
        case 2:
            filteredTransactions = transactions.filter{$0.transactionType == 1}
        default:
            break
        }
        switch sortSegmentController.selectedSegmentIndex {
        case 0:
            break
        case 1:
            filteredTransactions = filteredTransactions.sorted{$0.byn > $1.byn}
        default:
            break
        }
        if searchBar.text != "" {
            self.filteredTransactions = self.filteredTransactions.filter{$0.transactionCategory.lowercased().contains(searchBar.text!.lowercased())}
        }
    }
    
    func totalCalculation() {
        var sum: Float = 0.0
        for transaction in filteredTransactions {
            sum += transaction.byn
        }
        navigationItem.title = String(sum) + " б.р."
    }
    
    func updateData() {
        self.transactionTableView.reloadData()
        totalCalculation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TransactionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TransactionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TransactionTableViewCell.")
        }
        let transaction = filteredTransactions[indexPath.row]
        cell.byn.text = String(transaction.byn)
        cell.usd.text = String(transaction.usd)
        cell.eur.text = String(transaction.eur)
        cell.rub.text = String(transaction.rub)
        cell.date.text = String(transaction.date)
        cell.transactionCategory.text = transaction.transactionCategory
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filter()
        self.updateData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    @IBAction func unwindToTransactionsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TransactionViewController, let transaction = sourceViewController.transaction {
            //let newIndexPath = IndexPath(row: transactions.count, section: 0)
            //transactions.append(transaction)
            //let newIndexPath = IndexPath(row: 0, section: 0)
            transactions.insert(transaction, at: 0)
            //transactionTableView.insertRows(at: [newIndexPath], with: .automatic)
            saveTransactions()
            filter()
            updateData()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    private func saveTransactions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(transactions, toFile: Transaction.documentsDirectory.appendingPathComponent(Transaction.userName).path)
        if isSuccessfulSave {
            os_log("Transactions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save transactions...", log: OSLog.default, type: .error)
        }
    }
    private func loadTransactions() -> [Transaction]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Transaction.documentsDirectory.appendingPathComponent(Transaction.userName).path) as? [Transaction]
    }

}
