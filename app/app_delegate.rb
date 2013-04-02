class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    nav = UINavigationController.alloc.initWithRootViewController(StoriesController.alloc.init)
    nav.wantsFullScreenLayout = true
    nav.toolbarHidden = true
    
    navigationBar = UINavigationBar.appearance
    navigationBar.setTintColor '#ff6600'.to_color
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav
    @window.makeKeyAndVisible
    true
  end
end
