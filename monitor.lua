local monitor = { dps = {} }

function monitor.brightness_set(level)
  -- hl.notification.create({ text = "ddcutil -d 1 setvcp 10 " .. level, duration = 1000 })
  hl.exec_cmd("ddcutil -d 1 setvcp 10 " .. level)
end

function monitor.dps.brightness_set(level)
  return function()
    monitor.brightness_set(level)
  end
end

function monitor.brightness_get()
  hl.notification.create({ text = "Getting monitor brightness...", duration = 1000 })
  local handle = io.popen("ddcutil -d 1 getvcp 10")
  local output = handle:read("*a")
  handle:close()
  local current = output:match("current value%s*=%s*(%d+)")
  hl.notification.create({ text = "Monitor brightness: " .. current, duration = 4000 })
end

function monitor.dps.brightness_get()
  return function()
    monitor.brightness_get()
  end
end

function monitor.output(code)
  hl.exec_cmd("ddcutil -d 1 setvcp 60 " .. code)
end

function monitor.dps.output(code)
  return function()
    monitor.output(code)
  end
end

return monitor
