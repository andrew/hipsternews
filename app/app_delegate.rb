class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = Device.ipad? ? split_controller : nav_controller
    @window.makeKeyAndVisible
    true
  end

  def stories_controller
    @stories_controller ||= StoriesController.alloc.init
  end

  def nav_controller
    @nav_controller ||= begin
      nav = UINavigationController.alloc.initWithRootViewController(stories_controller)
      nav.wantsFullScreenLayout = true
      nav.toolbarHidden = false
      navigationBar = UINavigationBar.appearance
      navigationBar.setTintColor '#ff6600'.to_color
      navToolbar = UIToolbar.appearance
      navToolbar.setTintColor '#ff6600'.to_color
      nav
    end
  end

  def split_controller
    @split_controller ||= begin
      split = UISplitViewController.alloc.init
      split.viewControllers = [nav_controller, UINavigationController.alloc.initWithRootViewController(web_view_controller)]
      split.delegate = self
      split
    end
  end

  def web_view_controller
    @web_view ||= begin
      WebViewController.alloc.init
    end
  end
  
  def applicationDidBecomeActive(application)
    @stories_controller.loadData
    @stories_controller.tableView.setContentOffset(CGPoint.new(0,44))
  end
end
