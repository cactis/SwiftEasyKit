//
//  WebViewController.swift

import UIKit

open class WebViewController: DefaultViewController, UIWebViewDelegate {
  public var webView = UIWebView()
  var url: String? { didSet {
    if url != nil {
      webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }
    }}

  public init(title: String, url: String?) {
    super.init(nibName: nil, bundle: nil)
    titled(title, token: "WEBVC")
    ({ self.url = url })()
  }

  public var didFinishLoad: (_  webView: UIWebView,_ delegate: WebViewController) -> () = {_,_ in }

  open func webViewDidFinishLoad(_ webView: UIWebView) {
    didFinishLoad(webView, self)
  }

  open override func layoutUI() {
    super.layoutUI()
    webView.delegate = self
    view.layout([webView])
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.fillSuperview()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
