//
//  WebViewController.swift

import UIKit

open class WebViewController: DefaultViewController, UIWebViewDelegate {
  public var webView = UIWebView()
  var url: String! { didSet {
    let request = NSURLRequest(url: URL(string: url)!)
    webView.loadRequest(request as URLRequest)
    }}

  public var didFinishLoad: (_  webView: UIWebView,_ delegate: WebViewController) -> () = {_,_ in }

  public init(url: String) {
    super.init(nibName: nil, bundle: nil)
    ({ self.url = url })()
  }

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
