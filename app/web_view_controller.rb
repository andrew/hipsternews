class WebViewController < UIViewController
  def initWithURL(url)
     @url = url
     init
   end
  
  def viewDidLoad
    self.view = UIWebView.alloc.init
    url = NSURL.URLWithString(@url)
    request = NSURLRequest.requestWithURL(url)
    self.view.scalesPageToFit = true
    self.view.loadRequest request
  end
end