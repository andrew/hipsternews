Teacup::Stylesheet.new(:story_cell) do
  style :comments,
    width: 40,
    height: 45,
    top: 0,
    left: 280
  style :count,
    width: 40,
    top: 20,
    height: 20,
    color: '#555'.to_color,
    textAlignment: UITextAlignmentCenter,
    font: UIFont.systemFontOfSize(11)
  style :info,
    width: 280,
    height: 45,
    top: 0,
    left: 0
  style :title,
    width: 270,
    height: 23,
    top: 3,
    left: 10,
    font: UIFont.systemFontOfSize(14)
  style :description,
    width: 270,
    height: 18,
    top: 25,
    left: 10,
    font: UIFont.systemFontOfSize(10),
    color: '#555'.to_color
end