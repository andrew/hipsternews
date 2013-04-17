class WebViewController < UIViewController
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

    @flexible = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    @share_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction, target: self, action: 'share_button_action')

    loadWebview if @story
  end

  def webViewDidFinishLoad(webview)
    return if webview.isLoading
    @loading_view.stopAnimating()
  end

  def viewWillAppear(animated)
    navigationController.setToolbarHidden(false, animated:true)
    show_instapaper_button(animated)
  end

  def show_instapaper_button(animated)
    toolbar_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemBookmarks,
      target: self,
      action: :instapaper_view)
    self.setToolbarItems([toolbar_button, @flexible, @share_button], animated:animated)
  end

  def show_regular_button
    toolbar_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
        target: self,
        action: :regular_view)
    self.setToolbarItems([toolbar_button, @flexible, @share_button], animated:false)
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
    @loading_view.startAnimating()
    
    self.view.loadRequest NSURLRequest.requestWithURL(NSURL.URLWithString(url))
    navigationItem.title = @story['title']
  end

  def instapaper_view
    url = "http://www.instapaper.com/text?u=#{@story['url']}"
    loadWebview(url)
    show_regular_button
  end
  
  def regular_view
    loadWebview
    show_instapaper_button(false)
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