class HTML2Lucky::TagFactory
  TEXT_TAG_SYM    = :_text
  COMMENT_TAG_SYM = :_em_comment

  getter depth, tag

  def initialize(@tag : Lexbor::Node, @depth : Int32)
  end

  def build : Tag
    tag_class.new(tag, depth)
  end

  private def tag_class : Tag.class
    if text_tag?(tag)
      TextTag
    elsif comment_tag?(tag)
      CommentTag
    elsif single_line_tag?(tag)
      SingleLineTag
    else
      MultiLineTag
    end
  end

  def single_line_tag?(tag)
    return false if tag.children.to_a.size != 1
    child_tag = tag.children.to_a.first
    return false unless text_tag?(child_tag)
    return true if child_tag.tag_text =~ /\A\s*\Z/
    return false if child_tag.tag_text =~ /\n/
    true
  end

  def text_tag?(tag)
    tag.tag_sym == TEXT_TAG_SYM
  end

  def comment_tag?(tag)
    tag.tag_sym == COMMENT_TAG_SYM
  end
end