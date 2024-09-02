local wordHotkeys = {}

-- キーストローク関数（遅延付き）
local function keyStroke(modifiers, key, delay)
    return function()
        hs.timer.doAfter(delay or 0, function()
            hs.eventtap.keyStroke(modifiers, key, 50000)
        end)
    end
end

-- キーリピート関数
local function keyRepeat(modifiers, key)
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, key, true):post()
        hs.timer.usleep(10000)
        hs.eventtap.event.newKeyEvent(modifiers, key, false):post()
    end
end

-- Wordのみに適用されるキーの再マッピング
local function remapKeyForWord(modifiers, key, action)
    local hk = hs.hotkey.new(modifiers, key, action, nil, action)
    table.insert(wordHotkeys, hk)
end

-- Microsoft Word用のCtrl+Kで改行までカット
local function keyCtrlK()
    keyStroke({'cmd', 'shift'}, 'right', 0)()  -- 行末まで選択
    hs.timer.doAfter(0.05, function()
        keyStroke({'cmd'}, 'x', 0)()  -- 切り取り
    end)
end

-- Microsoft Word用のCtrl+x, u（元に戻す）
local function keyCtrlXU()
    keyStroke({'cmd'}, 'z', 0)()
end

-- Ctrl+x状態を管理するオブジェクト
local ctrlXManager = {
    pressed = false,
    timer = nil
}

-- Ctrl+xの状態をリセットする関数
function ctrlXManager:reset()
    self.pressed = false
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
end

-- キーイベントを処理するイベントタップ（Wordのみで有効）
local wordKeyWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    local keyCode = event:getKeyCode()
    if flags.ctrl and keyCode == 7 then  -- Ctrl+x
        ctrlXManager.pressed = true
        if ctrlXManager.timer then
            ctrlXManager.timer:stop()
        end
        ctrlXManager.timer = hs.timer.doAfter(0.5, function() ctrlXManager:reset() end)
    elseif ctrlXManager.pressed and keyCode == 32 then  -- u
        keyCtrlXU()
        ctrlXManager:reset()
        return true
    end
    return false
end)

-- Microsoft Word用の特別なキーマッピング
local function setupWordKeyMappings()
    remapKeyForWord({'ctrl'}, 'p', keyRepeat({}, 'up'))
    remapKeyForWord({'ctrl'}, 'n', keyRepeat({}, 'down'))
    remapKeyForWord({'ctrl'}, 'b', keyRepeat({}, 'left'))
    remapKeyForWord({'ctrl'}, 'f', keyRepeat({}, 'right'))
    remapKeyForWord({'ctrl'}, 'a', keyStroke({}, 'home'))
    remapKeyForWord({'ctrl'}, 'e', keyStroke({}, 'end'))
    remapKeyForWord({'ctrl'}, 'h', keyRepeat({}, 'delete'))
    remapKeyForWord({'ctrl'}, 'd', keyRepeat({}, 'forwarddelete'))
    remapKeyForWord({'alt'}, 'w', keyStroke({'cmd'}, 'c'))
    remapKeyForWord({'ctrl'}, 'w', keyStroke({'cmd'}, 'x'))
    remapKeyForWord({'ctrl'}, 'y', keyStroke({'cmd'}, 'v'))
    remapKeyForWord({'ctrl'}, 'm', keyStroke({}, 'return'))
    remapKeyForWord({'ctrl'}, 'k', keyCtrlK)
end

-- Wordでホットキーを有効化
local function enableWordHotkeys()
    for _, hk in ipairs(wordHotkeys) do
        hk:enable()
    end
    wordKeyWatcher:start()
end

-- Wordでホットキーを無効化
local function disableWordHotkeys()
    for _, hk in ipairs(wordHotkeys) do
        hk:disable()
    end
    wordKeyWatcher:stop()
end

-- アプリケーションイベントの処理
local function handleGlobalAppEvent(name, event, app)
    if event == hs.application.watcher.activated then
        local appNameLower = name:lower()
        if appNameLower == "microsoft word" then
            enableWordHotkeys()
        else
            disableWordHotkeys()
        end
    end
end

-- アプリケーションウォッチャーの設定
local appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

-- 初期設定
setupWordKeyMappings()local wordHotkeys = {}

-- キーストローク関数（遅延付き）
local function keyStroke(modifiers, key, delay)
    return function()
        hs.timer.doAfter(delay or 0, function()
            hs.eventtap.keyStroke(modifiers, key, 50000)
        end)
    end
end

-- キーリピート関数
local function keyRepeat(modifiers, key)
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, key, true):post()
        hs.timer.usleep(10000)
        hs.eventtap.event.newKeyEvent(modifiers, key, false):post()
    end
end

-- Wordのみに適用されるキーの再マッピング
local function remapKeyForWord(modifiers, key, action)
    local hk = hs.hotkey.new(modifiers, key, action, nil, action)
    table.insert(wordHotkeys, hk)
end

-- Microsoft Word用のCtrl+Kで改行までカット
local function keyCtrlK()
    keyStroke({'cmd', 'shift'}, 'right', 0)()  -- 行末まで選択
    hs.timer.doAfter(0.05, function()
        keyStroke({'cmd'}, 'x', 0)()  -- 切り取り
    end)
end

-- Microsoft Word用のCtrl+x, u（元に戻す）
local function keyCtrlXU()
    keyStroke({'cmd'}, 'z', 0)()
end

-- Ctrl+x状態を管理するオブジェクト
local ctrlXManager = {
    pressed = false,
    timer = nil
}

-- Ctrl+xの状態をリセットする関数
function ctrlXManager:reset()
    self.pressed = false
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
end

-- キーイベントを処理するイベントタップ（Wordのみで有効）
local wordKeyWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    local keyCode = event:getKeyCode()
    if flags.ctrl and keyCode == 7 then  -- Ctrl+x
        ctrlXManager.pressed = true
        if ctrlXManager.timer then
            ctrlXManager.timer:stop()
        end
        ctrlXManager.timer = hs.timer.doAfter(0.5, function() ctrlXManager:reset() end)
        return true  -- イベントを消費してWordのデフォルト動作を防ぐ
    elseif ctrlXManager.pressed and keyCode == 32 then  -- u
        keyCtrlXU()
        ctrlXManager:reset()
        return true
    end
    return false
end)

-- Microsoft Word用の特別なキーマッピング
local function setupWordKeyMappings()
    remapKeyForWord({'ctrl'}, 'p', keyRepeat({}, 'up'))
    remapKeyForWord({'ctrl'}, 'n', keyRepeat({}, 'down'))
    remapKeyForWord({'ctrl'}, 'b', keyRepeat({}, 'left'))
    remapKeyForWord({'ctrl'}, 'f', keyRepeat({}, 'right'))
    remapKeyForWord({'ctrl'}, 'a', keyStroke({}, 'home'))
    remapKeyForWord({'ctrl'}, 'e', keyStroke({}, 'end'))
    remapKeyForWord({'ctrl'}, 'h', keyRepeat({}, 'delete'))
    remapKeyForWord({'ctrl'}, 'd', keyRepeat({}, 'forwarddelete'))
    remapKeyForWord({'alt'}, 'w', keyStroke({'cmd'}, 'c'))
    remapKeyForWord({'ctrl'}, 'w', keyStroke({'cmd'}, 'x'))
    remapKeyForWord({'ctrl'}, 'y', keyStroke({'cmd'}, 'v'))
    remapKeyForWord({'ctrl'}, 'm', keyStroke({}, 'return'))
    remapKeyForWord({'ctrl'}, 'k', keyCtrlK)
    
    -- Ctrl+xのデフォルト動作を無効化
    remapKeyForWord({'ctrl'}, 'x', function() end)
end

-- Wordでホットキーを有効化
local function enableWordHotkeys()
    for _, hk in ipairs(wordHotkeys) do
        hk:enable()
    end
    wordKeyWatcher:start()
end

-- Wordでホットキーを無効化
local function disableWordHotkeys()
    for _, hk in ipairs(wordHotkeys) do
        hk:disable()
    end
    wordKeyWatcher:stop()
end

-- アプリケーションイベントの処理
local function handleGlobalAppEvent(name, event, app)
    if event == hs.application.watcher.activated then
        local appNameLower = name:lower()
        if appNameLower == "microsoft word" then
            enableWordHotkeys()
        else
            disableWordHotkeys()
        end
    end
end

-- アプリケーションウォッチャーの設定
local appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)
appsWatcher:start()

-- 初期設定
setupWordKeyMappings()