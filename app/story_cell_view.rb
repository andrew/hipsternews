class StoryCell < UITableViewCell

  CellID = 'CellIdentifier'
  MessageFontSize = 14
  
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      # self.textLabel.numberOfLines = 2
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
      self.detailTextLabel.font = UIFont.systemFontOfSize(MessageFontSize-2)
    end
    self
  end
end