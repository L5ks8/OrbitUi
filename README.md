```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/L5ks8/UiLibary/main/loader.lua?t=" .. os.time()))()  --Load the UiLibary

--//Create window
local Window = Library:CreateWindow({
    Title = "Test UI",                                                  -- Name the Ui
    Version = "1.0.0",                                                  -- Version of the Ui
    Theme = "Dark",                                                     -- Set a Theme you defined you dont need to standart is dark
    Logo = "<font color=\"rgb(0, 170, 255)\">Test</font>UI",          -- Add the name of the Logo it supports multi colour Names
    SecondaryLogo = "| UI Example",                                     -- The secondary Logo it can be the game name o annything

    -- Custom themes
    Themes = {                                                          -- Define the Themes here
        Dark = {
            Main = Color3.fromRGB(35,35,35),                            -- Background Colour
            Accent = Color3.fromRGB(0,170,255)                          -- Accent Colour
        },

        Red = {
            Main = Color3.fromRGB(40,20,20),
            Accent = Color3.fromRGB(255,80,80)
        }
    },

    -- Runs when UI closes                                              
    OnClose = function()
        print("UI closed!")                                             -- Can have a Custom on close Event                        
    end
})

-- Create main Tab                                                      -- Create the main Tab using Window:CreateTab
local MainTab = Window:CreateTab({
    Name = "Main",                                                      -- Name of the Tab
    Icon = "11433532654",                                               -- Icon of the Tab
    Columns = true,                                                     -- Enable/Disable Colums
    Searchbar = true                                                    -- Enable/Disable Searchbar on top of the Tabs
})

-- Left section
local LeftSection = MainTab:CreateSection({                             -- Create Sections using the name of the tab so MainTab:CreateSection, the toggles buttons or annything after the section is automatically addet to it
    Title = "Buttons & Toggles",                                        -- Title of the Section
    Column = "Left",                                                    -- Choose the colum Left or Right
    Droppable = true                                                    -- Droppable makes the Section foldable
})

-- Button
LeftSection:CreateButton("Test Button", function()                      -- Create a Button you can choose between the sections so LeftSection or RightSection
    print("Button clicked!")                                            -- Add the Function of the Button Here
end)

-- Toggle
LeftSection:CreateToggle({                                              -- Create a Toggle usign the same method as the button 
    Title = "Test Toggle",                                              -- Name of the Toggle
    Default = false,                                                    -- Default state of the Toggle so false off and true on

    Callback = function(state)
        print("Toggle state:", state)                                   -- Add the Function of the Toggle Here 
    end
})

-- Slider
LeftSection:CreateSlider({                                              -- Create a Slider using the same method as the Toggle and Button
    Title = "Test Slider",                                              -- Name of the Slider
    Min = 0,                                                            -- Minimum Value
    Max = 100,                                                          -- Maximum Value
    Default = 50,                                                       -- Default Value
    Suffix = "%",                                                       -- Add any suffix to the value like % or ms or anything else can be left empty ""                                                                      

    Callback = function(value)
        print("Slider value:", value)                                   -- Add the Function of the Slider Here
    end
})

-- Keybind                                                              -- Create an input field for annything 
LeftSection:CreateKeybind({
    Title = "UI Keybind",               
    Default = Enum.KeyCode.RightControl,                                -- Set default here

    Callback = function(key)
        print("New key:", key.Name)
    end
})

-- Right section
local RightSection = MainTab:CreateSection({                            
    Title = "Dropdowns & Text",                                         
    Column = "Right",
    Droppable = true
})

-- Dropdown
local Dropdown = RightSection:CreateDropdown({                          -- Create a Dropdown using the section you want it to be and :CreateDropdown
    Title = "Test Dropdown",                                            -- Name of the Dropdown
    Options = {
        "Option 1",                                                     -- List of options for the Dropdown you can add as many as you want
        "Option 2",
        "Option 3"
    },
    Default = "Option 1",                                               -- Set default here
    Searchbar = true,                                                   -- Enable/Disable Searchbar for the Dropdown 

    Callback = function(value)
        print("Selected:", value)
    end
})

-- Label
local Label = RightSection:CreateLabel({                                -- Create a Status Label using the section you want it to be and :CreateLabel
    Title = "Status",                                                   -- Status Name of the Label like "next event in" and then the timer 
    Default = "Waiting..."                                              -- Default text of the Label                                                                        
--[[task.delay(5, function()                                    
    Label:Set("UI loaded successfully!")                                -- Define the function here or later     
end)]]                                          
})

-- Paragraph
RightSection:CreateParagraph({
    Text = "This is a simple text paragraph inside the UI."             -- Paragraphs are just text that can be used for description
})

-- Avatar preview
RightSection:CreateAvatar("Avatar Preview")                             -- Create an Avatar preview name it as you like you can later use it as an esp preview

-- Settings tab
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "11293977610",
    SecondaryTab = true                                                 -- You can Create Up to 2 Secondary tabs that are seperatet from the main ones and listet aboth the User info
})                                                                      -- Settings tab is empty

-- About tab
local AboutTab = Window:CreateTab({
    Name = "About",
    Icon = "11419720347",
    SecondaryTab = true
})

local InfoSection = AboutTab:CreateSection("Information")

InfoSection:CreateParagraph({
    Text = "Made by L5ks8."
})

InfoSection:CreateParagraph({
    Text = "Pretty good UiLibary."
})

-- Change label after 5 seconds                                         
task.delay(5, function()                                                -- Define the Label functions
    Label:Set("UI loaded successfully!")
end)
```

