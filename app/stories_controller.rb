class StoriesController < UITableViewController
  stylesheet :story_cell

  def viewDidLoad
    super
    @data = []
    loadData
    tableView.addPullToRefreshWithActionHandler(Proc.new { loadData })
    tableView.addInfiniteScrollingWithActionHandler(Proc.new { loadMore })
    
    search_bar = UISearchBar.alloc.initWithFrame([[0,0],[320,44]])
    search_bar.delegate = self
    search_bar.setTintColor '#ff6600'.to_color
    view.addSubview(search_bar)
    view.tableHeaderView = search_bar
  end

  def viewDidAppear(animated)
    UIApplication.sharedApplication.delegate.nav_controller.setToolbarHidden(true, animated:false)
    tableView.setContentOffset(CGPoint.new(0,44))
  end

  def loadData
    BW::HTTP.get("http://node-hnapi.herokuapp.com/news") do |response|
      if response.ok?
        begin
          BW::JSON.parse response.body.to_str do |json|
            @data = json
            view.reloadData
            @more_loaded = false
          end
        rescue
          App.alert("API error, please try again")
        end
      else
        App.alert(response.error_message)
      end
      tableView.pullToRefreshView.stopAnimating
      tableView.setContentOffset(CGPoint.new(0,44))
    end
  end

  def loadMore
    if @more_loaded
      tableView.infiniteScrollingView.stopAnimating
      return
    end

    BW::HTTP.get("http://node-hnapi.herokuapp.com/news2") do |response|
      if response.ok?
        begin
          BW::JSON.parse response.body.to_str do |json|
            @data = @data + json
            view.reloadData
            @more_loaded = true
          end
        rescue
          App.alert("API error, please try again")
        end
      else
        App.alert(response.error_message)
      end
      tableView.infiniteScrollingView.stopAnimating
    end
  end
  
  def searchBarShouldBeginEditing(search_bar)
    search_bar.setShowsCancelButton true, animated:true
  end
  
  def searchBarSearchButtonClicked(search_bar)
    search_bar.resignFirstResponder
    navigationItem.title = "Search for '#{search_bar.text}'"
    @original_data = @data
    @data = @data.select{|d| d['title'] =~ /#{search_bar.text}/i } || []
    view.reloadData
    search_bar.subviews[2].setEnabled(true)
  end
  
  def searchBarCancelButtonClicked(search_bar)
    navigationItem.title = "HipsterNews"
    search_bar.resignFirstResponder
    @data = @original_data
    view.reloadData
    search_bar.text = ""
    #tableView.setContentOffset(CGPoint.new(0,44))
  end

  def viewWillAppear(animated)
    navigationItem.title = 'HipsterNews'
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @data.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || StoryCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    story = @data[indexPath.row]
    cell.populate(story)
    cell.selectionTintColor = '#ff6600'.to_color
    cell
  end
end