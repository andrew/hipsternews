class StoriesController < UITableViewController
  stylesheet :story_cell

  def viewDidLoad
    super
    @data = []
    loadData
    tableView.addPullToRefreshWithActionHandler(Proc.new { loadData })
    tableView.addInfiniteScrollingWithActionHandler(Proc.new { loadMore })
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
    
    if story['type'] == 'link'
      story['description'] = "#{story['points']} points - #{story['time_ago']} by #{story['user']} - #{story['domain']}"
    else
      story['description'] = "#{story['type']} - #{story['time_ago']}"
      story['url'] = "https://news.ycombinator.com/#{story['url']}"
    end
    
    layout(cell.contentView, :cell) do
      @info_view = subview(UIView, :info) do
        title_view = subview(UILabel, :title)
        title_view.text = story['title']
        desc_view = subview(UILabel, :description)
        desc_view.text = story['description']
      end
      @comments_view = subview(UIView, :comments) do
        count_view = subview(UILabel, :count)
        count_view.text = story['comments_count'].to_s
      end
    end
    
    @info_view.when_tapped do
      if Device.ipad?
        UIApplication.sharedApplication.delegate.web_view_controller.loadStory(story)
      else
        view_controller = WebViewController.alloc.initWithStory(story)
        navigationItem.title = 'Back'
        self.parentViewController.pushViewController(view_controller, animated: true)
      end
    end
    
    @comments_view.when_tapped do
      puts 'comments tapped'
    end
    
    cell.selectionTintColor = '#ff6600'.to_color
    cell
  end
end