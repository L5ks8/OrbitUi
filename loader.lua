local Url = "https://raw.githubusercontent.com/L5ks8/OrbitUi/main/Ui/"
local componentsUrl = Url .. "Components/"

local success1, content1 = pcall(game.HttpGet, game, Url .. "MainUi/mainfunctions.lua?t=" .. os.time())
local success2, content2 = pcall(game.HttpGet, game, Url .. "MainUi/mainframe.lua?t=" .. os.time())

if not (success1 and success2) then
    error("Orbit Ui: Failed to load files from GitHub.")
end

local function compileScript(source, description)
    if type(source) ~= "string" then
        return nil, description .. " source is not a string"
    end

    local chunk, compileError = loadstring(source)
    if not chunk then
        return nil, compileError
    end

    local success, result = pcall(chunk)
    if not success then
        return nil, result
    end

    return result
end

local mainfunctions, err1 = compileScript(content1, "mainfunctions")
if not mainfunctions then
    error("Orbit Ui: Failed to compile mainfunctions.lua: " .. tostring(err1))
end

local mainframe, err2 = compileScript(content2, "mainframe")
if not mainframe then
    error("Orbit Ui: Failed to compile mainframe.lua: " .. tostring(err2))
end

local components = {}
local componentNames = {"button", "toggle", "slider", "status", "paragraph", "dropdown", "avatar", "input", "uikeybind", "notification"}

for _, name in ipairs(componentNames) do
    local success, content = pcall(game.HttpGet, game, componentsUrl .. name .. ".lua?t=" .. os.time())
    if success then
        local component, err = compileScript(content, name)
        if component then
            components[name] = component
        else
            error("Orbit Ui: Failed to compile component '" .. name .. "': " .. tostring(err))
        end
    else
        error("Orbit Ui: Failed to load component '" .. name .. "' from GitHub.")
    end
end

local successProfile, contentProfile = pcall(game.HttpGet, game, Url .. "MainUi/profile.lua?t=" .. os.time())
if successProfile then
    local profileModule, err = compileScript(contentProfile, "profile")
    if profileModule then
        components.profile = profileModule
    else
        warn("Orbit Ui: Failed to compile profile.lua: " .. tostring(err))
    end
else
    warn("Orbit Ui: Failed to load profile module from GitHub.")
end

if mainframe and mainfunctions then
    return mainframe(mainfunctions, components)
else
    error("Orbit Ui: Failed to compile mainframe or mainfunctions.")
end
