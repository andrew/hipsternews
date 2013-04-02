class WebViewController < UIViewController
  def initWithStory(story)
     @story = story
     init
   end

  def viewDidLoad
    self.view = UIWebView.alloc.init
    self.view.scalesPageToFit = true
    loadURL(@story['url']) if @story
  end

  def loadStory(story)
    @story = story
    loadURL(@story['url'])
    navigationItem.title = @story['title']
  end

  def loadURL(url)
    self.view.loadRequest NSURLRequest.requestWithURL(NSURL.URLWithString(url))
  end

  def viewWillAppear(animated)
    navigationItem.title = @story['title'] if @story
  end
end