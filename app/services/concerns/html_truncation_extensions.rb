# frozen_string_literal: true

module HtmlTruncationExtensions
  extend ActiveSupport::Concern

  included do
    # Overridden because the method in the core removes newlines from the
    # truncated text which cause the words between different tags to be stuck
    # together.
    def perform
      @document = Nokogiri::HTML::DocumentFragment.parse(@text)
      @tail_added = false
      @remaining = initial_remaining
      @cut = false
      cut_children(document, options[:count_tags])
      add_tail(document) if @remaining.negative? && !@tail_added
      escape_html_from_content(document)

      # Nokogiri's to_html escapes &quot; to &amp;quot; and we do not want extra &amp so we have to unescape.
      CGI.unescape_html(document.to_html)
    end
  end
end
