class CommentsController < UIViewController
  def initWithStory(story)
     @story = story
     init
   end

  def viewDidLoad
    self.view = UIWebView.alloc.init
    self.view.scalesPageToFit = true
    self.view.delegate = self
    @loading_view = UIActivityIndicatorView.new
    @loading_view.frame = [[0,0],[30,30]]
    @loading_button = UIBarButtonItem.alloc.initWithCustomView(@loading_view)
    navigationItem.setRightBarButtonItem(@loading_button, true)

    loadURL("https://news.ycombinator.com/item?id=#{@story['id']}")
  end

  def loadURL(url)
    @loading_view.startAnimating()
    self.view.loadRequest NSURLRequest.requestWithURL(NSURL.URLWithString(url))
  end

  def webViewDidFinishLoad(webview)
    return if webview.isLoading
    puts "loaded" 
    @loading_view.stopAnimating()
  end

  def viewWillAppear(animated)
    navigationItem.title = @story['title'] if @story
  end
end