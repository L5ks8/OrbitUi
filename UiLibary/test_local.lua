-- Local Test Script for GoonHub UI Library
-- Run this script inside a Roblox Executor or Studio Command Bar (if configured for readfile)

getgenv().GoonHubDev = true -- Activates local loading of mainfunktions.lua from disk

-- Load the Mainframe UI library locally
local Library = loadstring(readfile("Ui/mainframe.lua"))()

-- Create a main window
local Window = Library:CreateWindow({
    Title = "GoonHub",
    Version = "1.0.0",
    Theme = "Dark",
    OnClose = function()
        print("UI successfully closed!")
    end
})

-- Create a navigation tab
local HomeTab = Window:CreateTab("Home", "11433532654")

-- Create a section inside the tab
local Section = HomeTab:CreateSection("General Settings")

-- Add a button widget
Section:CreateButton("Click Me!", function()
    print("Button was pressed!")
end)

-- Add a toggle widget
Section:CreateToggle("Enable Cheat", false, function(state)
    print("Cheat active:", state)
end)

-- Add a slider widget
Section:CreateSlider("Walkspeed", 16, 100, 16, function(value)
    print("Walkspeed set to:", value)
end)

-- Add a dropdown widget
local Dropdown = Section:CreateDropdown("Select Weapon", {"M4A1", "AK-47", "AWP", "Knife"}, function(weapon)
    print("Selected weapon:", weapon)
end)

-- Add a label widget
local Label = Section:CreateLabel("Current Status", "Idle")

-- Add a paragraph widget
Section:CreateParagraph("Welcome to the new GoonHub UI Library! This version features a single-column layout, smooth color theme transitions, and optimized frame rate counters.")

-- Simulate changing the label after 5 seconds
task.delay(5, function()
    Label:Set("Running Hacks...")
end)
