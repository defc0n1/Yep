//
//  GeniusInterviewViewController.swift
//  Yep
//
//  Created by NIX on 16/6/29.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import UIKit
import WebKit

class GeniusInterviewViewController: UIViewController {

    lazy var webView: WKWebView = {

        let view = WKWebView()

        view.navigationDelegate = self

        view.scrollView.contentInset.bottom = 50
        view.scrollView.delegate = self

        let request = NSURLRequest(URL: NSURL(string: "https://soyep.com")!)
        view.loadRequest(request)

        return view
    }()

    lazy var indicatorView: UIActivityIndicatorView = {

        let view = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        view.hidesWhenStopped = true
        return view
    }()

    private var actionViewTopConstraint: NSLayoutConstraint?
    lazy var actionView: GeniusInterviewActionView = {

        let view = GeniusInterviewActionView()

        view.tapAvatarAction = {
            println("tapAvatarAction")
        }

        view.sayHiAction = {
            println("sayHiAction")
        }

        view.shareAction = {
            println("shareAction")
        }

        return view
    }()

    deinit {
        webView.scrollView.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(webView)

            let leading = webView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
            let trailing = webView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
            let top = webView.topAnchor.constraintEqualToAnchor(view.topAnchor)
            let bottom = webView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
            NSLayoutConstraint.activateConstraints([leading, trailing, top, bottom])
        }

        do {
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(indicatorView)

            let centerX = indicatorView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
            let centerY = indicatorView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
            NSLayoutConstraint.activateConstraints([centerX, centerY])
        }

        do {
            actionView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(actionView)

            let leading = actionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor)
            let trailing = actionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor)
            let top = actionView.topAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: 0)
            self.actionViewTopConstraint = top
            let height = actionView.heightAnchor.constraintEqualToConstant(50)
            NSLayoutConstraint.activateConstraints([leading, trailing, top, height])
        }
    }
}

// MARK: - WKNavigationDelegate

extension GeniusInterviewViewController: WKNavigationDelegate {

    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        indicatorView.startAnimating()
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {

        indicatorView.stopAnimating()
    }
}

// MARK: - UIScrollViewDelegate

extension GeniusInterviewViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

        let scrollViewContentOffsetY = scrollView.contentOffset.y
        guard scrollViewContentOffsetY > 0 else {
            return
        }
        let scrollViewHeight = scrollView.bounds.height
        let scrollViewContentSizeHeight = scrollView.contentSize.height

        //println("scrollViewContentOffsetY: \(scrollViewContentOffsetY)")
        //println("scrollViewHeight: \(scrollViewHeight)")
        //println("scrollViewContentSizeHeight: \(scrollViewContentSizeHeight)")

        let y = (scrollViewContentOffsetY + scrollViewHeight) - scrollViewContentSizeHeight
        if y > 0 {
            UIView.animateWithDuration(0.25, animations: { [weak self] in
                self?.actionViewTopConstraint?.constant = -50
                self?.view.layoutIfNeeded()
            })
        } else {
            UIView.animateWithDuration(0.25, animations: { [weak self] in
                self?.actionViewTopConstraint?.constant = 0
                self?.view.layoutIfNeeded()
            })
        }
    }
}

