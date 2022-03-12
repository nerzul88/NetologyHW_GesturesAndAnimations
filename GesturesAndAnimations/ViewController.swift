//
//  ViewController.swift
//  GesturesAndAnimations
//
//  Created by Александр Касьянов on 11.03.2022.
//

import UIKit

class ViewController: UIViewController {

    private lazy var avatarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var alphaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Milwaukee_Bucks.jpeg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var wallPaperImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "wallPaper")
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(self.didTapSetStatusButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var avatarViewCenterXConstraint: NSLayoutConstraint?
    private var avatarViewCenterYConstraint: NSLayoutConstraint?
    private var avatarViewHeightConstraint: NSLayoutConstraint?
    private var avatarViewWidthConstraint: NSLayoutConstraint?
    private var isExpanded = false
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        title = "Жесты и анимация"
        self.setupView()
        self.setupGesture()
    }
    
    private func setupView() {
        view.addSubview(wallPaperImageView)
        view.addSubview(alphaView)
        view.addSubview(avatarView)
        avatarView.addSubview(avatarImageView)
        view.bringSubviewToFront(alphaView)
        view.addSubview(closeButton)
        view.bringSubviewToFront(avatarView)
        avatarView.layer.cornerRadius = 75
        alphaView.alpha = 0
        
        self.avatarViewCenterXConstraint = self.avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -1 * (screenWidth * 0.5 - 91))
        self.avatarViewCenterYConstraint = self.avatarView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -1 * (screenHeight * 0.5 - 166))
        self.avatarViewHeightConstraint = self.avatarView.heightAnchor.constraint(equalToConstant: 150)
        self.avatarViewWidthConstraint = self.avatarView.widthAnchor.constraint(equalToConstant: 150)

        NSLayoutConstraint.activate([
            self.avatarViewCenterXConstraint, self.avatarViewCenterYConstraint,
            self.avatarViewHeightConstraint, self.avatarViewWidthConstraint,
            avatarImageView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            wallPaperImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wallPaperImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wallPaperImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            wallPaperImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            alphaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            alphaView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            alphaView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            alphaView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40)
        ].compactMap({ $0 }))
    }
    
    private func setupGesture() {
        self.tapGestureRecognizer.addTarget(self, action: #selector(self.handleTapGesture(_ :)))
        self.avatarView.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard self.tapGestureRecognizer === gestureRecognizer else { return }
        self.isExpanded.toggle()
        self.avatarViewCenterXConstraint?.constant = self.isExpanded ? 0 : -1 * (screenWidth * 0.5 - 91)
        self.avatarViewCenterYConstraint?.constant = self.isExpanded ? 0 : -1 * (screenHeight * 0.5 - 166)
        self.avatarViewHeightConstraint?.constant = self.isExpanded ? screenWidth : 150
        self.avatarViewWidthConstraint?.constant = self.isExpanded ? screenWidth : 150
        
        UIView.animate(withDuration: 0.5) {
            self.avatarView.layer.cornerRadius = self.isExpanded ? 0 : 75
            self.alphaView.alpha = self.isExpanded ? 0.7 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
        
        if self.isExpanded {
            self.alphaView.isHidden = false
            self.closeButton.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.5) {
            self.closeButton.alpha = self.isExpanded ? 1 : 0
        } completion: { _ in
            self.closeButton.isHidden = !self.isExpanded
        }
    }
    
    @objc private func didTapSetStatusButton() {
        self.avatarViewCenterXConstraint?.constant = -1 * (screenWidth * 0.5 - 91)
        self.avatarViewCenterYConstraint?.constant = -1 * (screenHeight * 0.5 - 166)
        self.avatarViewHeightConstraint?.constant = 150
        self.avatarViewWidthConstraint?.constant = 150
        
        UIView.animate(withDuration: 0.5) {
            self.avatarView.layer.cornerRadius = 75
            self.alphaView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.5) {
            self.closeButton.alpha = 0
        } completion: { _ in
            self.closeButton.isHidden = false
            self.isExpanded = false
        }
    }

}

