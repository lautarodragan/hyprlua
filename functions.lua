local functions = {}

function functions.next_window_in_ws()
  local ws = hl.get_active_workspace()
  local layout = ws and ws.tiled_layout

  if layout == "dwindle" then
    hl.dispatch(hl.dsp.window.cycle_next())
  elseif layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("focus r"))
  elseif layout == "monocle" then
    hl.dispatch(hl.dsp.layout("cyclenext"))
  else
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.layout("cyclenext"))
  end
end

function functions.previous_window_in_ws()
  local ws = hl.get_active_workspace()
  local layout = ws and ws.tiled_layout

  if layout == "dwindle" then
    hl.dispatch(hl.dsp.window.cycle_next())
  elseif layout == "scrolling" then
    hl.dispatch(hl.dsp.layout("focus l"))
  elseif layout == "monocle" then
    hl.dispatch(hl.dsp.layout("cycleprev"))
  else
    hl.dispatch(hl.dsp.window.cycle_prev())
    hl.dispatch(hl.dsp.layout("cycleprev"))
  end
end

function functions.window_x(window)
  local at = window.at

  if type(at) == "table" then
    return at.x or at[1] or 0
  end

  return at or 0
end

function functions.focus_leftmost_window_in_ws(ws)
  local windows = hl.get_workspace_windows(ws.id)
  local leftmost = nil

  for _, window in ipairs(windows) do
    if window.mapped and not window.hidden and not window.floating then
      if not leftmost or functions.window_x(window) < functions.window_x(leftmost) then
        leftmost = window
      end
    end
  end

  if leftmost then
    hl.dispatch(hl.dsp.focus({ window = leftmost }))
  end
end

function functions.focus_first_window_in_ws()
  local ws = hl.get_active_workspace()
  local layout = ws and ws.tiled_layout

  if not ws then
    return
  elseif layout == "scrolling" then
    functions.focus_leftmost_window_in_ws(ws)
  elseif layout == "monocle" then
    -- Monocle clients all report the same position. Hyprland keeps a
    -- cycle order internally, but it is not exposed through the Lua API.
  end
end

function functions.set_active_workspace_layout(layout)
  return function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    hl.workspace_rule({ workspace = ws.id, layout = layout })
  end
end

function functions.resize_window(length)
  return function()
    local ws = hl.get_active_workspace()
    local layout = ws and ws.tiled_layout

    local length_s
    if length < 0 then
      length_s = tostring(length)
    else
      length_s = "+" .. tostring(length)
    end

    if layout == "dwindle" then
      hl.dispatch(hl.dsp.layout("splitratio " .. length_s))
    elseif layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("colresize " .. length_s))
    end
  end
end

function functions.resize_half()
  local mon = hl.get_active_monitor()
  if not mon then return end
  hl.dispatch(hl.dsp.window.resize({
    x = mon.width  / mon.scale * 0.5,
    y = mon.height / mon.scale * 0.5,
    relative = false,
  }))
end

function functions.zoom_next()
  local value = hl.get_config("cursor.zoom_factor")
  local next_zoom = {
    [1.0] = 2,
    [2.0] = 4,
  }

  hl.config({
    cursor = {
      zoom_factor = next_zoom[value] or 1,
    },
  })
end

return functions
