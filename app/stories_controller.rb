class StoriesController < UITableViewController
  def viewDidLoad
    super
    @data = []
    loadData
    tableView.addPullToRefreshWithActionHandler(
      Proc.new do
        p 'load'
        loadData
      end
    )
    tableView.addInfiniteScrollingWithActionHandler(
      Proc.new do
        p 'more'
        loadMore
      end
    )
  end

  def loadData
    BW::HTTP.get("http://hndroidapi.appspot.com/news/format/json/page/") do |response|
      if response.ok?
        begin
          BW::JSON.parse response.body.to_str do |json|
            items = json['items']
            @data = @data + items[0..29]
            @next = items[30]['url']
            view.reloadData
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
    url = @next || 'news/format/json/page/'

    BW::HTTP.get("http://hndroidapi.appspot.com/#{url}") do |response|
      if response.ok?
        begin
          BW::JSON.parse response.body.to_str do |json|
            items = json['items']
            @data = @data + items[0..29]
            @next = items[30]['url']
            view.reloadData
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
    navigationItem.title = 'Hacker News'
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @data.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    story = @data[indexPath.row]
    cell.textLabel.text = story['title']
    cell.detailTextLabel.text = story['description']
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    story = @data[indexPath.row]
    view_controller = WebViewController.alloc.initWithURL(story['url'])
    self.parentViewController.pushViewController(view_controller, animated: true)
  end
end