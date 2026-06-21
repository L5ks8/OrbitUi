local Url = "https://raw.githubusercontent.com/L5ks8/OrbitUi/main/Ui/"
local componentsUrl = Url .. "Components/"

local success1, content1 = pcall(game.HttpGet, game, Url .. "MainUi/mainfunctions.lua?t=" .. os.time())
local success2, content2 = pcall(game.HttpGet, game, Url .. "MainUi/mainframe.lua?t=" .. os.time())

if not (success1 and success2) then
    error("Orbit Ui: Failed to load files from GitHub.")
end

local mainfunctions = loadstring(content1)()
local mainframe = loadstring(content2)()

-- Load all components in parallel for faster startup
local components = {}
local componentNames = {"button", "toggle", "slider", "status", "paragraph", "dropdown", "avatar", "input", "uikeybind", "notification", "profile", "loading", "spectate", "freecam"}
local loadedCount = 0
local totalCount = #componentNames
local loadErrors = {}

for _, name in ipairs(componentNames) do
    task.spawn(function()
        local success, content = pcall(game.HttpGet, game, componentsUrl .. name .. ".lua?t=" .. os.time())
        if success then
            local compSuccess, result = pcall(loadstring(content))
            if compSuccess then
                components[name] = result
            else
                table.insert(loadErrors, name)
            end
        else
            table.insert(loadErrors, name)
        end
        loadedCount = loadedCount + 1
    end)
end

-- Wait for all components to finish loading
repeat task.wait() until loadedCount >= totalCount

if #loadErrors > 0 then
    error("Orbit Ui: Failed to load component(s): " .. table.concat(loadErrors, ", "))
end

if mainframe and mainfunctions then
    return mainframe(mainfunctions, components)
else
    error("Orbit Ui: Failed to compile mainframe or mainfunctions.")
end
