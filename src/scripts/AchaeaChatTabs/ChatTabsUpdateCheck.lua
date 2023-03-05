function AchaeaChatTabs.RetrieveUpdateInfo()
    getHTTP("https://api.github.com/repos/TheLastDarkthorne/AchaeaChatTabs/releases/latest")
  end

  function AchaeaChatTabs.UpdateWarning(version)
    if not version then return end
    if version > getPackageInfo("AchaeaChatTabs","version") then
      return cecho("<green>AchaeaChatTabs:<yellow> There is a new version of AchaeaChatTabs! To update, please do 'act update'<reset>\n")
    end
  end

  function AchaeaChatTabs.GetVersion(_, url, body)
    if url ~= "https://api.github.com/repos/TheLastDarkthorne/AchaeaChatTabs/releases/latest" then return end
    local content = yajl.to_value(body)
    return AchaeaChatTabs.UpdateWarning(content.tag_name)
  end

  registerNamedEventHandler("AchaeaChatTabs", "UpdateHandler", "sysGetHttpDone", AchaeaChatTabs.GetVersion)
  registerNamedEventHandler("AchaeaChatTabs", "UpdateCheck", "sysLoadEvent", AchaeaChatTabs.RetrieveUpdateInfo)