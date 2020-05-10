c.confirm_quit = ["downloads","multiple-tabs"]
c.downloads.location.directory = "~/net"
c.editor.command = ["kitty", "nvim '{}'"]

# Leave insert mode if a non-editable element is clicked.
c.input.insert_mode.auto_leave = True

# Automatically enter insert mode if an editable element is focused
# after loading the page.
c.input.insert_mode.auto_load = True

# Show a scrollbar.
c.scrolling.bar = 'always'

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
c.scrolling.smooth = True

# Behavior when the last tab is closed.
# Valid values:
#   - ignore: Don't do anything.
#   - blank: Load a blank page.
#   - startpage: Load the start page.
#   - default-page: Load the default page.
#   - close: Close the window.
c.tabs.last_close = "default-page"

# Padding around text for tabs
c.tabs.padding = {
    "left": 5,
    "right": 5,
    "top": 0,
    "bottom": 1,
}

# Which tab to select when the focused tab is removed.
# Valid values:
#   - prev: Select the tab which came before the closed one (left in horizontal, above in vertical).
#   - next: Select the tab which came after the closed one (right in horizontal, below in vertical).
#   - last-used: Select the previously selected tab.
c.tabs.select_on_remove = "prev"

# The page to open if :open -t/-b/-w is used without URL. Use
# `about:blank` for a blank page.
c.url.default_page ="https://google.com"

# The page(s) to open at the start.
c.url.start_pages = "https://google.com"

# Definitions of search engines which can be used via the address bar.
# Maps a searchengine name (such as `DEFAULT`, or `ddg`) to a URL with a
# `{}` placeholder. The placeholder will be replaced by the search term,
# use `{{` and `}}` for literal `{`/`}` signs. The searchengine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
c.url.searchengines = {"DEFAULT": "https://www.google.fi/search?q={}"}

# Open new tabs (middleclick/ctrl+click) in the background.
c.tabs.background = True
c.qt.highdpi

#
c.auto_save.session = True

# A list of user stylesheet filenames to use.
c.content.user_stylesheets = "user.css"

config.source('font.py')
config.source('keybind.py')
config.source('qutewal.py')
