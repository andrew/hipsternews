Teacup::Stylesheet.new(:story_cell) do
  style :comments,
    width: 40,
    height: 45,
    top: 0,
    left: 280

  style :count,
    width: 40,
    top: 10,
    height: 20,
    color: '#aaa'.to_color,
    textAlignment: UITextAlignmentCenter,
    font: UIFont.systemFontOfSize(10),
    backgroundColor: UIColor.clearColor

  style :icon,
    image: UIImage.imageNamed("comments.png"),
    width: 24,
    top: 12,
    height: 19,
    left: 8

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