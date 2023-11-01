----------------------------------------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------------------------------------
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(false)
hs.uploadCrashData(false)

hs.window.animationDuration = 0

configWatcher = hs.pathwatcher.new(hs.configdir, hs.reload)
configWatcher:start()

local moonlanderMode = false
local maximizeMode = false

----------------------------------------------------------------------------------------------------
-- Utilities
----------------------------------------------------------------------------------------------------

local modifier = {
    cmd = "cmd",
    shift = "shift",
    ctrl = "ctrl",
    option = "alt",
}

local modifiers = {
    hyper = { modifier.cmd, modifier.shift },
    window = { modifier.ctrl, modifier.option },
    clipboard = { modifier.ctrl, modifier.cmd }
}

local bundleID = {
    activityMonitor = "com.apple.ActivityMonitor",
    finder = "com.apple.finder",
    firefox = "org.mozilla.firefox",
    emacs = "org.gnu.emacs",
    iterm = "com.googlecode.iterm2",
    safari = "com.apple.Safari",
    safariTechnologyPreview = "com.apple.SafariTechnologyPreview",
    spotify = "com.spotify.client",
    bitwarden = "com.bitwarden.desktop",
    teams = "com.microsoft.teams",
    faclieThings = "com.electron.nativefier.facilethings-nativefier-cf88de",
    timeular = "com.timeular.zei",
    logseq = "com.electron.logseq"
}

local usbDevice = {
    moonlander = "Moonlander Mark I"
}

local function languageIsGerman() return hs.host.locale.preferredLanguages()[1]:sub(0, 2) == "de" end

local function maximizeCurrentWindow() hs.window.focusedWindow():maximize() end

local function centerCurrentWindow() hs.window.focusedWindow():centerOnScreen() end

local function moveCurrentWindowToLeftHalf()
    local win = hs.window.focusedWindow()
    local screenFrame = win:screen():frame()
    local newFrame = hs.geometry.rect(screenFrame.x, screenFrame.y, screenFrame.w / 2, screenFrame.h)
    win:setFrame(newFrame)
end

local function moveCurrentWindowToRightHalf()
    local win = hs.window.focusedWindow()
    local screenFrame = win:screen():frame()
    local newFrame = hs.geometry.rect(screenFrame.x + screenFrame.w / 2, screenFrame.y, screenFrame.w / 2, screenFrame.h)
    win:setFrame(newFrame)
end

local function moveCurentWindowToNextScreen()
    local win = hs.window.focusedWindow()
    win:moveToScreen(win:screen():next())
end

local function moveMouseToWindowCenter()
    local windowCenter = hs.window.frontmostWindow():frame().center
    hs.mouse.absolutePosition(windowCenter)
end

local function moveMouseToUpperLeft()
    local screenFrame = (hs.window.focusedWindow():screen() or hs.screen.primaryScreen()):frame()
    local newPoint = hs.geometry.point(screenFrame.x + screenFrame.w / 4, screenFrame.y + screenFrame.h / 4)
    hs.mouse.absolutePosition(newPoint)
end

local function moveMouseToUpperRight()
    local screenFrame = (hs.window.focusedWindow():screen() or hs.screen.primaryScreen()):frame()
    local newPoint = hs.geometry.point(screenFrame.x + screenFrame.w * 3 / 4, screenFrame.y + screenFrame.h / 4)
    hs.mouse.absolutePosition(newPoint)
end

local function moveMouseToLowerLeft()
    local screenFrame = (hs.window.focusedWindow():screen() or hs.screen.primaryScreen()):frame()
    local newPoint = hs.geometry.point(screenFrame.x + screenFrame.w / 4, screenFrame.y + screenFrame.h * 3 / 4)
    hs.mouse.absolutePosition(newPoint)
end

local function moveMouseToLowerRight()
    local screenFrame = (hs.window.focusedWindow():screen() or hs.screen.primaryScreen()):frame()
    local newPoint = hs.geometry.point(screenFrame.x + screenFrame.w * 3 / 4, screenFrame.y + screenFrame.h * 3 / 4)
    hs.mouse.absolutePosition(newPoint)
end

----------------------------------------------------------------------------------------------------
-- Menu
----------------------------------------------------------------------------------------------------

local function menuItems()
    return {
        {
            title = "Hammerspoon " .. hs.processInfo.version,
            disabled = true
        },
        { title = "-" },
        
        {
            title = "Maximize Mode",
            checked = maximizeMode,
            fn = function() maximizeMode = not maximizeMode end
        },
        { title = "-" },
        {
            title = "Reload",
            fn = hs.reload
        },
        {
            title = "Console...",
            fn = hs.openConsole
        },
        { title = "-" },
        {
            title = "Quit",
            fn = function() hs.application.get(hs.processInfo.processID):kill() end
        }
    }
end

menu = hs.menubar.new()
menu:setMenu(menuItems)


----------------------------------------------------------------------------------------------------
-- Window Management
----------------------------------------------------------------------------------------------------


hs.window.filter.ignoreAlways = {
    ["Mail Web Content"] = true,
    ["Mail-Webinhalt"] = true,
    ["QLPreviewGenerationExtension (Finder)"] = true,
    ["Reeder Web Content"] = true,
    ["Reeder-Webinhalt"] = true,
    ["Safari Web Content (Cached)"] = true,
    ["Safari Web Content (Prewarmed)"] = true,
    ["Safari Web Content"] = true,
    ["Safari Technology Preview Web Content (Cached)"] = true,
    ["Safari Technology Preview Web Content (Prewarmed)"] = true,
    ["Safari Technology Preview Web Content"] = true,
    ["Safari-Webinhalt (im Cache)"] = true,
    ["Safari-Webinhalt (vorgeladen)"] = true,
    ["Safari-Webinhalt"] = true,
    ["Strongbox (Safari)"] = true,
}
windowFilter = hs.window.filter.new({
    "App Store",
    "Code",
    "DataGrip",
    "Firefox",
    "Fork",
    "Fotos",
    "Google Chrome",
    "Vivaldi",
    "IntelliJ IDEA",
    "Mail",
    "Emacs",
    "Microsoft Outlook",
    "Microsoft Teams",
    "Music",
    "Musik",
    "Photos",
    "Postman",
    "Reeder",
    "Safari",
    "Safari Technology Preview",
    "Spotify",
    "Strongbox",
    "BitWarden",
    "Logseq",
    "Timeular",
    "Tower",
})
windowFilter:subscribe({ hs.window.filter.windowCreated, hs.window.filter.windowFocused }, function(window)
    if maximizeMode and window ~= nil and window:isStandard() and window:frame().h > 500 then
        window:maximize()
    end
end)


----------------------------------------------------------------------------------------------------
-- Keyboard Shortcuts
----------------------------------------------------------------------------------------------------

hs.hotkey.bind(modifiers.window, hs.keycodes.map.left, moveCurrentWindowToLeftHalf)
hs.hotkey.bind(modifiers.window, hs.keycodes.map.right, moveCurrentWindowToRightHalf)
hs.hotkey.bind(modifiers.window, hs.keycodes.map.down, moveCurentWindowToNextScreen)
hs.hotkey.bind(modifiers.window, hs.keycodes.map["return"], maximizeCurrentWindow)
hs.hotkey.bind(modifiers.window, "c", centerCurrentWindow)