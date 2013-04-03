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
    cell.populate(story)
    cell.selectionTintColor = '#ff6600'.to_color
    cell
  end
end