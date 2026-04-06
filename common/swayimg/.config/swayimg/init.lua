-- Example config for Swayimg.
-- This file contains the default configuration used by the application.

-- The viewer searches for the config file in the following locations:
-- 1. $XDG_CONFIG_HOME/swayimg/init.lua
-- 2. $HOME/.config/swayimg/init.lua
-- 3. $XDG_CONFIG_DIRS/swayimg/init.lua
-- 4. /etc/xdg/swayimg/init.lua


-- bind F12 to dump the entire undocumented v5 Lua API to the terminal
swayimg.viewer.on_key("F12", function()
  print("\n--- SWAYIMG VIEWER API ---")
  for k, v in pairs(swayimg.viewer) do
    if type(v) == "function" then print("swayimg.viewer." .. k) end
  end

  print("\n--- SWAYIMG CORE API ---")
  for k, v in pairs(swayimg) do
    if type(v) == "function" then print("swayimg." .. k) end
  end
end)




-- General config
swayimg.set_mode("viewer")                -- mode at startup
swayimg.enable_antialiasing(true)         -- anti-aliasing
swayimg.enable_decoration(true)           -- window title/buttons/borders
swayimg.enable_overlay(false)             -- window overlay mode
swayimg.enable_exif_orientation(true)     -- image orientation by EXIF
swayimg.set_dnd_button("MouseRight")      -- drag-and-drop mouse button

-- Image list configuration
swayimg.imagelist.set_order("numeric")    -- list order
swayimg.imagelist.enable_reverse(false)   -- reverse order
swayimg.imagelist.enable_recursive(false) -- recursive directory reading
swayimg.imagelist.enable_adjacent(true)   -- add adjacent files from same dir (FIXED for Dirvish)
swayimg.imagelist.enable_fsmon(true)      -- enable file system monitoring

-- Text overlay configuration
swayimg.text.set_font("monospace")        -- font name
swayimg.text.set_size(24)                 -- font size in pixels
swayimg.text.set_spacing(0)               -- line spacing
swayimg.text.set_padding(10)              -- padding from window edge
swayimg.text.set_foreground(0xffcccccc)   -- foreground text color
swayimg.text.set_background(0x00000000)   -- text background color
swayimg.text.set_shadow(0x0d000000)       -- text shadow color
swayimg.text.set_timeout(0)               -- layer hide timeout (FIXED to 0 for toggle)
swayimg.text.set_status_timeout(0)        -- status message hide timeout (FIXED to 0 for toggle)

-- Image viewer mode
swayimg.viewer.set_default_scale("optimal")      -- default image scale
swayimg.viewer.set_default_position("center")    -- default image position
swayimg.viewer.set_drag_button("MouseLeft")      -- mouse button to drag image
swayimg.viewer.set_window_background(0xff000000) -- window background color
swayimg.viewer.set_image_chessboard(20, 0xff333333, 0xff4c4c4c) -- chessboard
swayimg.viewer.enable_centering(true)            -- enable automatic centering
swayimg.viewer.enable_loop(true)                 -- enable image list loop mode
swayimg.viewer.limit_preload(1)                  -- number of images to preload
swayimg.viewer.limit_history(1)                  -- number of the history cache
swayimg.viewer.set_mark_color(0xff808080)        -- mark icon color
swayimg.viewer.set_text("topleft", {})
swayimg.viewer.set_text("topright", {})
swayimg.viewer.set_text("bottomleft", {})

-- Key and mouse bindings in viewer mode:

-- bind 'i' to act as a perfect ON/OFF toggle for the BIG text overlay
local info_is_on = true -- It starts ON by default based on config above
local full_topleft = {
  "File: {name}", "Format: {format}", "File size: {sizehr}",
  "File time: {time}", "EXIF date: {meta.Exif.Photo.DateTimeOriginal}",
  "EXIF camera: {meta.Exif.Image.Model}"
}
local full_topright = {
  "Image: {list.index} of {list.total}", "Frame: {frame.index} of {frame.total}",
  "Size: {frame.width}x{frame.height}"
}
local full_bottomleft = { "Scale: {scale}" }

swayimg.viewer.on_key("Tab", function()
  info_is_on = not info_is_on

  if info_is_on then
    -- Turn ON: Inject the big templates back into the viewer
    swayimg.viewer.set_text("topleft", full_topleft)
    swayimg.viewer.set_text("topright", full_topright)
    swayimg.viewer.set_text("bottomleft", full_bottomleft)
  else
    -- Turn OFF: Pass empty arrays to hide them instantly
    swayimg.viewer.set_text("topleft", {})
    swayimg.viewer.set_text("topright", {})
    swayimg.viewer.set_text("bottomleft", {})
  end

  -- Also clear that tiny bottom status bar just to be clean
  swayimg.text.set_status("")
end)

-- bind Escape key for exit
swayimg.viewer.on_key("Escape", function() swayimg.exit() end)
swayimg.viewer.on_key("q",      function() swayimg.exit() end)


-- bind i, k, j, l to pan the image up, down, left, right (Vim style)
local pan_step = 10 -- Move by 1/10th of the window size
swayimg.viewer.on_key("i", function()
  local wnd, pos = swayimg.get_window_size(), swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y + wnd.height / pan_step))
end)
swayimg.viewer.on_key("k", function()
  local wnd, pos = swayimg.get_window_size(), swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y - wnd.height / pan_step))
end)
swayimg.viewer.on_key("j", function()
  local wnd, pos = swayimg.get_window_size(), swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width / pan_step), pos.y)
end)
swayimg.viewer.on_key("l", function()
  local wnd, pos = swayimg.get_window_size(), swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x - wnd.width / pan_step), pos.y)
end)

-- Core navigation and flipping using the new v5 Viewer API
swayimg.viewer.on_key("o", function() swayimg.viewer.switch_image("next") end)
swayimg.viewer.on_key("u", function() swayimg.viewer.switch_image("prev") end)
swayimg.viewer.on_key("n", function() swayimg.viewer.flip_horizontal() end)


-- bind the left arrow key to move the image to the left by 1/10 of the application window size
swayimg.viewer.on_key("Left", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width / 10), pos.y);
end)

-- bind mouse vertical scroll button with pressed Ctrl to zoom in the image at mouse pointer coordinates
swayimg.viewer.on_mouse("Ctrl-ScrollUp", function()
  local pos = swayimg.get_mouse_pos()
  local scale = swayimg.viewer.get_scale()
  scale = scale + scale / 10
  swayimg.viewer.set_abs_scale(scale, pos.x, pos.y);
end)

-- bind 'd' to launch Ripdrag on the currently viewed image
swayimg.viewer.on_key("d", function()
  local image = swayimg.viewer.get_image()
  -- %q safely quotes the path. 2>/dev/null & cleanly detaches the Wayland window.
  os.execute(string.format("ripdrag %q 2>/dev/null &", image.path))
end)

-- Slide show mode, same config as for viewer mode with the following defaults:
swayimg.slideshow.set_timeout(5)                    -- timeout to switch image
swayimg.slideshow.set_default_scale("fit")          -- default image scale
swayimg.slideshow.set_window_background("auto")     -- window background mode
swayimg.slideshow.limit_history(0)                  -- number of the history cache
swayimg.slideshow.set_text("topleft", { "{name}" }) -- top left text block scheme

-- Gallery mode
swayimg.gallery.set_aspect("fill")                  -- thumbnail aspect ratio
swayimg.gallery.set_thumb_size(200)                 -- thumbnail size in pixels
swayimg.gallery.set_padding_size(5)                 -- padding between thumbnails
swayimg.gallery.set_border_size(5)                  -- border size for selected thumbnail
swayimg.gallery.set_border_color(0xffaaaaaa)        -- border color for selected thumbnail
swayimg.gallery.set_selected_scale(1.15)            -- scale for selected thumbnail
swayimg.gallery.set_selected_color(0xff404040)      -- background color for selected thumbnail
swayimg.gallery.set_unselected_color(0xff202020)    -- background color for unselected thumbnail
swayimg.gallery.set_window_color(0xff000000)        -- window background color
swayimg.gallery.limit_cache(100)                    -- number of thumbnails stored in memory
swayimg.gallery.enable_preload(false)               -- preloading invisible thumbnails
swayimg.gallery.enable_pstore(false)                -- enable persistent storage for thumbnails
swayimg.gallery.set_text("topleft", {               -- top left text block scheme
  "File: {name}"
})
swayimg.gallery.set_text("topright", {              -- top right text block scheme
  "{list.index} of {list.total}"
})

-- Key and mouse bindings in gallery mode (example only, not all):

-- bind Enter key to open image in viewer
swayimg.gallery.on_key("Return", function()
  swayimg.set_mode("viewer")
end)
-- bind the left arrow key to select thumbnail on the left side
swayimg.gallery.on_key("Left", function()
  swayimg.gallery.switch_image("left")
end)

-- Other configuration examples

-- force set scale mode on window resize (useful for tiling compositors)
swayimg.on_window_resize(function()
  swayimg.viewer.set_fix_scale("optimal")
end)

-- bind the Delete key in slide show mode to delete the current file and display a status message
swayimg.slideshow.on_key("Delete", function()
  local image = swayimg.slideshow.get_image()
  os.remove(image.path)
  swayimg.text.set_status("File "..image.path.." removed")
end)

-- set a custom window title in gallery mode
swayimg.gallery.on_image_change(function()
  local image = swayimg.gallery.get_image()
  swayimg.set_title("Gallery: "..image.path)
end)

-- print paths to all marked files by pressing Ctrl-p in gallery mode
swayimg.gallery.on_key("Ctrl-p", function()
  local entries = swayimg.imagelist.get()
  for _, entry in ipairs(entries) do
    if entry.mark then
        print(entry.path)
    end
  end
end)
