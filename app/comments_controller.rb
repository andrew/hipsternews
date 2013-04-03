class CommentsController < UIViewController
  def initWithStory(story)
     @story = story
     init
   end

  def viewDidLoad
    self.view = UIWebView.alloc.init
    self.view.scalesPageToFit = true
    loadURL("https://news.ycombinator.com/item?id=#{@story['id']}")
  end

  def loadURL(url)
    self.view.loadRequest NSURLRequest.requestWithURL(NSURL.URLWithString(url))
  end

  def viewWillAppear(animated)
    navigationItem.title = @story['title'] if @story
  end
end