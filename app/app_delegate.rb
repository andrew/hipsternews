class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = Device.ipad? ? split_controller : nav_controller
    @window.makeKeyAndVisible
    true
  end

  def nav_controller
    @nav_controller ||= begin
      nav = UINavigationController.alloc.initWithRootViewController(StoriesController.alloc.init)
      nav.wantsFullScreenLayout = true
      nav.toolbarHidden = true

      navigationBar = UINavigationBar.appearance
      navigationBar.setTintColor '#ff6600'.to_color
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
end
