//
//  ChatCell.swift
//  Infince
//
//  Created by Habeeb Rahman on 15/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    let lblMessage = UILabel()
    let msgBackgroundView = UIView()
    var leadingConstraint: NSLayoutConstraint!
    var leadingConstraintTime: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var trailingConstraintTime: NSLayoutConstraint!
    
    let lblTime = UILabel()
    var isIncoming: Bool! {
        didSet{
            msgBackgroundView.backgroundColor = isIncoming ? .white : .darkGray
            lblMessage.textColor = isIncoming ? .black : .white
            if isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
                
                leadingConstraintTime.isActive = true
                trailingConstraintTime.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                leadingConstraintTime.isActive = false
                trailingConstraintTime.isActive = true
            }
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         backgroundColor = .clear   
        msgBackgroundView.backgroundColor = .yellow
        msgBackgroundView.layer.cornerRadius = 16
        msgBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(msgBackgroundView)
        
        addSubview(lblMessage)
        //lblMessage.backgroundColor = .green
        lblMessage.text = "A very common task in iOS is to provide auto sizing cells for UITableView components. In today's lesson we look at how to implement a custom cel"
        lblMessage.numberOfLines = 0
        
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        let constraints =  [
            lblMessage.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            lblMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            lblMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
            msgBackgroundView.topAnchor.constraint(equalTo: lblMessage.topAnchor, constant: -16),
            msgBackgroundView.leadingAnchor.constraint(equalTo: lblMessage.leadingAnchor, constant: -16),
            msgBackgroundView.bottomAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 16),
            msgBackgroundView.trailingAnchor.constraint(equalTo: lblMessage.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = lblMessage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = lblMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
        
        
        addSubview(lblTime)
        lblTime.text="21/03/2020 12:30 PM"
        lblTime.font = lblTime.font.withSize(12)
        lblTime.textColor = .lightGray
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        let constraintsTime =  [
            lblTime.topAnchor.constraint(equalTo: lblMessage.bottomAnchor, constant: 20),
            lblTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            lblTime.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ]
        leadingConstraintTime = lblTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        leadingConstraintTime.isActive = false
        
        trailingConstraintTime = lblTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        trailingConstraintTime.isActive = true
        NSLayoutConstraint.activate(constraintsTime)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
