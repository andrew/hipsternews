class StoryCell < UITableViewCell
  def stylesheet
    Teacup::Stylesheet[:story_cell]
  end

  def initWithFrame(frame)
    super.tap { init_subviews }
  end

  def initWithStyle(style, reuseIdentifier:id)
    super.tap { init_subviews }
  end

  def init_subviews
    layout(contentView, :cell) do
      @info_view = subview(UIView, :info) do
        @title_view = subview(UILabel, :title)
        @desc_view = subview(UILabel, :description)
      end
      @comments_view = subview(UIView, :comments) do
        @count_view = subview(UILabel, :count)
      end
    end
  end

  def populate(story)
    if story['type'] == 'link'
      story['description'] = "#{story['points']} points - #{story['time_ago']} by #{story['user']} - #{story['domain']}"
    else
      story['description'] = "#{story['type']} - #{story['time_ago']}"
      story['url'] = "https://news.ycombinator.com/#{story['url']}"
    end
    @title_view.text = story['title']
    @desc_view.text = story['description']
    @count_view.text = story['comments_count'].to_s
    
    @info_view.when_tapped do
      if Device.ipad?
        UIApplication.sharedApplication.delegate.web_view_controller.loadStory(story)
      else
        view_controller = WebViewController.alloc.initWithStory(story)
        UIApplication.sharedApplication.delegate.nav_controller.pushViewController(view_controller, animated: true)
      end
    end

    @comments_view.when_tapped do
      puts 'comments tapped'
    end
  end
end