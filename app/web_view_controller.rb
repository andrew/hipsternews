class WebViewController < UIViewController
  def initWithStory(story)
     @story = story
     init
   end

  def viewDidLoad
    self.view = UIWebView.alloc.init
    self.view.scalesPageToFit = true
    loadWebview if @story
  end

  def loadStory(story)
    @story = story
    loadWebview
  end

  def loadComments(story)
    @story = story
    loadWebview("https://news.ycombinator.com/item?id=#{@story['id']}")
  end

  def loadWebview(url = @story['url'])
    self.view.loadRequest NSURLRequest.requestWithURL(NSURL.URLWithString(url))
    navigationItem.title = @story['title']
    share_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction, target: self, action: 'share_button_action')
    navigationItem.setRightBarButtonItem(share_button, true)
  end

  def share_button_action
    activityViewController = UIActivityViewController.alloc.initWithActivityItems(["#{@story['title']} - #{@story['url']}"], applicationActivities:nil)
    if Device.iphone?
      self.presentViewController(activityViewController, animated:true, completion:nil)
    else
      open_share_popup(activityViewController)
    end
  end

  def open_share_popup(activityViewController)
    rect = [[Device.screen.width, -8], [1, 1]]
    @popup = UIPopoverController.alloc.initWithContentViewController(activityViewController)
    @popup.presentPopoverFromRect(rect, inView:self.view, permittedArrowDirections:UIPopoverArrowDirectionUp, animated:true)
  end
end