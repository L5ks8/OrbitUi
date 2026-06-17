local baseUrl = "https://raw.githubusercontent.com/L5ks8/UiLibary/main/Ui/"

local success1, content1 = pcall(game.HttpGet, game, baseUrl .. "mainfunctions.lua?t=" .. os.time())
local success2, content2 = pcall(game.HttpGet, game, baseUrl .. "mainframe.lua?t=" .. os.time())

local mainfunctions, mainframe
if success1 and success2 then
    mainfunctions = loadstring(content1)()
    mainframe = loadstring(content2)()
else
    error("GoonHub Loader: Failed to fetch files from GitHub.")
end

if mainframe and mainfunctions then
    return mainframe(mainfunctions)
else
    error("GoonHub Loader: Failed to compile mainframe or mainfunctions.")
end
