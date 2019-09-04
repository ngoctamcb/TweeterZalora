//
//  ViewController.swift
//  TweeterZalora
//
//  Created by Tran Ngoc Tam on 9/4/19.
//  Copyright © 2019 Tran Ngoc Tam. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputMessageView: UIView!
    
    var listMessageSplit: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        KeyboardAvoiding.avoidingView = inputMessageView
        inputTextField.text = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBAction func didTapSend(_ sender: Any) {
        
        listMessageSplit += Helper.tweet(messageInput: inputTextField.text!, limit: 50)
        tableView.reloadData()
        inputTextField.text = ""
    }
    
    @IBAction func didTapClear(_ sender: Any) {
        
        listMessageSplit = []
        tableView.reloadData()
        inputTextField.text = ""
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listMessageSplit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = listMessageSplit[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
