--[[----------------------------------------------------------------------------

  Author : Alexander Stoica
  Creation date : 08/01/2025
  Last modified : 08/06/2025

  https://renoise.github.io/xrnx/start/tool.html

----------------------------------------------------------------------------]]--

-- Set the variables below as needed.

--[[ manifest.xml required ]]-----------------------------------------------]]--

-- Should match the folder name of your tool exactly, without the .xrnx at the
-- end.
local MANIFEST_ID = "com.yourDomain.HelloWorld"

-- The version of the Renoise API your tool is using. This should be 6.2 for the
-- latest version (Renoise 3.5).
local MANIFEST_API_VERSION = "6.2"

-- The version of your tool. Whenever you release a new update, you should
-- increase the version. Note that this is a number value and not a semantic
-- version. So 1.02 is a valid version, while 1.0.2 is not.
local MANIFEST_VERSION = "1.0"

-- Your name and contact information. Whenever your tool crashes, this
-- information is going to be provided for the user alongside the crash message.
-- You should provide a contact method where you can receive bug reports or
-- questions.
local MANIFEST_AUTHOR = "Your Name [your@email.com]"

-- The human-readable name of your tool. It can be anything you want, and you
-- can change it anytime you feel like it.
local MANIFEST_NAME = "Hello World"

--[[ manifest.xml optional ]]-----------------------------------------------]]--

-- One or more categories for your tool, separated via comma, which will be used
-- to categorize your tool on the official Tools page if you ever decide to
-- submit it there. Valid list of categories:
-- Analysis, Automation, Bridge, Coding, Control, Development, DSP, Editing,
-- Export, Game, Generator, Hardware, Import, Instrument, Integration, Live,
-- MIDI, Mixing, Modulation, Networking, OSC, Pattern, Phrase, Plugin,
-- Recording, Rendering, Sample, Sequencer, Slicing, Tuning, Workflow
local MANIFEST_CATEGORY = ""

-- A short description of your tool which will be displayed inside the Tool
-- Browser in Renoise and on the official Tools page.
local MANIFEST_DESCRIPTION = ""

-- Windows, Mac, Linux
local MANIFEST_PLATFORM = ""

-- The type of license, e.g., MIT or AGPL.
local MANIFEST_LICENSE = ""

-- Relative path to the license file within the XRNX bundle.
local MANIFEST_LICENSE_PATH = ""

-- Relative path to the thumbnail icon file for the Tools page. 120x45px
local MANIFEST_THUMBNAIL_PATH = ""

-- Relative path to the cover image file for the Tools page. 600x350px
local MANIFEST_COVER_PATH = ""

-- Relative path to a plain text or markdown documentation file.
local MANIFEST_DOCUMENTATION_PATH = ""

-- The URL of your tool's homepage.
local MANIFEST_HOMEPAGE = ""

-- A URL to a website where your tool's documentation can be viewed.
local MANIFEST_DOCUMENTATION = ""

-- The URL of your tool's discussion page, e.g., on the Renoise forums.
local MANIFEST_DISCUSSION = ""

-- The URL of your tool's source code repository.
local MANIFEST_REPOSITORY = ""

-- A URL to a website where donations can be made to support your tool.
local MANIFEST_DONATE = ""

--[[ customizable globals ]]------------------------------------------------]]--

-- Either WINDOWS, MACINTOSH or LINUX, should be autodetected but can be set
-- manually.
local OS = ""

-- Path to Renoise preferences main folder, can be set here if defaults fail.
local RENOISE_PREFERENCES = ""

-- Renoise version number, matches version number in Renoise preferences folder.
-- If you want to target a lower version than the most recent, set it here.
local RENOISE_VERSION = ""

-- The project script folder can be used for Renoise terminal scripts, the
-- content will be copied.
local SCRIPT_FOLDER_NAME = "script"

-- The project tool folder contains all files which are packed into a tool, the
-- content will be copied and a *.xrnx file will be created for distribution in
-- the projects output folder.
local TOOL_FOLDER_NAME = "tool"

-- The packed version of your tool will be placed here.
local OUTPUT_FOLDER_NAME = "out"

-- Remove preferences.xml before copying and packing the tool.
local CLEAN_PREFERENCES_XML = true

--[[ code ]]----------------------------------------------------------------]]--

print("xrnx-make.lua running...\n")

-- try to detect operating system by checking the binary format of lua
if OS == "" then
  OS = package.cpath:match("%p[\\|/]?%p(%a+)")
  if OS == "dll" then
    OS = "WINDOWS"
  elseif OS == "dylib" then
    OS = "MACINTOSH"
  elseif OS == "so" then
    OS = "LINUX"
  else
    OS = ""
  end
end
if OS ~= "WINDOWS" and OS ~= "MACINTOSH" and OS ~= "LINUX" then
  print("Error: Platform could not be detected, script aborted!")
  return
end
print("Platform: " .. OS)

-- set Renoise preferences path based on OS
if RENOISE_PREFERENCES == "" then
  if OS == "WINDOWS" then
    RENOISE_PREFERENCES = "%APPDATA%/Renoise/"
  elseif OS == "MACINTOSH" then
    RENOISE_PREFERENCES = "~/Library/Preferences/Renoise/"
  elseif OS == "LINUX" then
    RENOISE_PREFERENCES = "$HOME/.config/Renoise/"
  end
end
print("Renoise preferences folder: " .. RENOISE_PREFERENCES)

-- get the most recent Renoise version
if RENOISE_VERSION == "" then
  local versions = {}
  if OS == "WINDOWS" then
    local h = io.popen('dir "' .. RENOISE_PREFERENCES .. '" /b /ad 2> nul')
    if h ~= nil then
      h:flush()
      for version in h:lines() do
        table.insert(versions, version)
      end
      h:close()
    end
  elseif OS == "MACINTOSH" then
    -- todo
  elseif OS == "LINUX" then
    -- todo
  end
  if #versions > 0 then
    RENOISE_VERSION = versions[#versions]
  else
    print("Error: Renoise version could not be detected, script aborted!")
    return
  end
end
print("Renoise version: " .. RENOISE_VERSION)

-- look for a script and tool folder
local directories = {}
if OS == "WINDOWS" then
  local h = io.popen('dir "." /b /ad 2> nul')
  if h ~= nil then
    h:flush()
    for directory in h:lines() do
      table.insert(directories, directory)
    end
    h:close()
  end
elseif OS == "MACINTOSH" then
  -- todo
elseif OS == "LINUX" then
  -- todo
end
if #directories > 0 then
  local script_found, tool_found = false, false
  for _, directory in pairs(directories) do
    if string.lower(directory) == string.lower(SCRIPT_FOLDER_NAME) then
      script_found = true
      print("\nA project script folder was found.")
      print('Copying the contents of ./' .. SCRIPT_FOLDER_NAME .. '/ to '
        .. RENOISE_PREFERENCES .. RENOISE_VERSION .. '/Scripts/'
      )
      if OS == "WINDOWS" then
        local h = io.popen('xcopy /s /e /h /i /y "./' .. SCRIPT_FOLDER_NAME
          .. '" "' .. RENOISE_PREFERENCES .. RENOISE_VERSION .. '/Scripts"'
        )
        if h ~= nil then
          h:flush()
          for line in h:lines() do
            line = string.gsub(line, "\\", "/") 
            print(line)
          end
          h:close()
        end
      elseif OS == "MACINTOSH" then
        -- todo
      elseif OS == "LINUX" then
        -- todo
      end
    elseif string.lower(directory) == string.lower(TOOL_FOLDER_NAME) then
      tool_found = true
      print("\nA project tool folder was found.")
      local filenames = {}
      if OS == "WINDOWS" then
        local h = io.popen('dir "./' .. TOOL_FOLDER_NAME .. '" /b /a-d 2> nul')
        if h ~= nil then
          h:flush()
          for filename in h:lines() do
            table.insert(filenames, filename)
          end
          h:close()
        end
      elseif OS == "MACINTOSH" then
        -- todo
      elseif OS == "LINUX" then
        -- todo
      end
      local manifest, main_lua, cover, thumbnail = false, false, false, false
      local readme, license, preferences = false, false, false
      if #filenames > 0 then
        for _, file in pairs(filenames) do
          if string.lower(file) == "manifest.xml" then
            manifest = true
          elseif string.lower(file) == "main.lua" then
            main_lua = true
          elseif string.lower(file) == "cover.png" then
            cover = true
          elseif string.lower(file) == "thumbnail.png" then
            thumbnail = true
          elseif string.lower(file) == "readme.md" then
            readme = true
          elseif string.lower(file) == "license" then
            license = true
          elseif string.lower(file) == "preferences.xml" then
            preferences = true
          end
        end
      end
      if string.find(string.lower(MANIFEST_COVER_PATH), ".png$") then
        cover = true
      elseif string.find(string.lower(MANIFEST_THUMBNAIL_PATH), ".png$") then
        thumbnail = true
      elseif MANIFEST_DOCUMENTATION_PATH ~= "" then
        readme = true
      elseif MANIFEST_LICENSE_PATH ~= "" then
        license = true
      end
      if manifest then
        print("Overwriting ./" .. TOOL_FOLDER_NAME .. "/manifest.xml")
      else
        print("Saving ./" .. TOOL_FOLDER_NAME .. "/manifest.xml")
      end
      local h = io.open("./" .. TOOL_FOLDER_NAME .. "/manifest.xml", "w+")
      if h ~= nil then
        local function xml_encode(string, tag)
          string:gsub('"', "&quot;")
          string:gsub("'", "&apos;")
          string:gsub("<", "&lt;")
          string:gsub(">", "&gt;")
          string:gsub("&", "&amp;")
          return '  <' .. tag .. '>' .. string .. '</' .. tag .. '>\n'
        end
        h:write('<?xml version="1.0" encoding="UTF-8"?>\n')
        h:write('<RenoiseScriptingTool doc_version="0">\n')
        h:write(xml_encode(MANIFEST_ID, "Id"))
        h:write(xml_encode(MANIFEST_API_VERSION, "ApiVersion"))
        h:write(xml_encode(MANIFEST_VERSION, "Version"))
        h:write(xml_encode(MANIFEST_AUTHOR, "Author"))
        h:write(xml_encode(MANIFEST_NAME, "Name"))
        if MANIFEST_CATEGORY ~= "" then
          h:write(xml_encode(MANIFEST_CATEGORY, "Category"))
        end
        if MANIFEST_DESCRIPTION ~= "" then
          h:write(xml_encode(MANIFEST_DESCRIPTION, "Description"))
        end
        if MANIFEST_PLATFORM ~= "" then
          h:write(xml_encode(MANIFEST_PLATFORM, "Platform"))
        end
        if MANIFEST_LICENSE ~= "" then
          h:write(xml_encode(MANIFEST_LICENSE, "License"))
        end
        if MANIFEST_LICENSE_PATH ~= "" then
          h:write(xml_encode(MANIFEST_LICENSE_PATH, "LicensePath"))
        end
        if MANIFEST_THUMBNAIL_PATH ~= "" then
          h:write(xml_encode(MANIFEST_THUMBNAIL_PATH, "ThumbnailPath"))
        end
        if MANIFEST_COVER_PATH ~= "" then
          h:write(xml_encode(MANIFEST_COVER_PATH, "CoverPath"))
        end
        if MANIFEST_DOCUMENTATION_PATH ~= "" then
          h:write(xml_encode(MANIFEST_DOCUMENTATION_PATH, "DocumentationPath"))
        end
        if MANIFEST_HOMEPAGE ~= "" then
          h:write(xml_encode(MANIFEST_HOMEPAGE, "Homepage"))
        end
        if MANIFEST_DOCUMENTATION ~= "" then
          h:write(xml_encode(MANIFEST_DOCUMENTATION, "Documentation"))
        end
        if MANIFEST_DISCUSSION ~= "" then
          h:write(xml_encode(MANIFEST_DISCUSSION, "Discussion"))
        end
        if MANIFEST_REPOSITORY ~= "" then
          h:write(xml_encode(MANIFEST_REPOSITORY, "Repository"))
        end
        if MANIFEST_DONATE ~= "" then
          h:write(xml_encode(MANIFEST_DONATE, "Donate"))
        end
        h:write('</RenoiseScriptingTool>\n')
        h:flush()
        h:close()
      end
      if not main_lua then
        print("Generating ./" .. TOOL_FOLDER_NAME .. "/main.lua")
        local h = io.open("./" .. TOOL_FOLDER_NAME .. "/main.lua", "w+")
        if h ~= nil then
          h:write('_AUTO_RELOAD_DEBUG = true\n\n')
          h:write('renoise.tool():add_menu_entry {\n')
          h:write('  name = "Main Menu:Tools:Hello World",\n')
          h:write('  invoke = function()\n')
          h:write('    renoise.app():show_prompt("Info", "Hello World",'
            .. '{"OK"})\n'
          )
          h:write('  end\n')
          h:write('}\n')
          h:flush()
          h:close()
        end
      end
      if cover then
        if MANIFEST_COVER_PATH == "" then
          print('Info: A "cover.png" file was found but is not declared in '
            ..  '"manifest.xml."'
          )
        else
          local f = io.open("./" .. TOOL_FOLDER_NAME .. "/"
            .. MANIFEST_COVER_PATH, "r"
          )
          if f ~= nil then
            io.close(f)
            print('Found cover file "' .. MANIFEST_COVER_PATH .. '".')
          else
            print('Warning: Cover file "' .. MANIFEST_COVER_PATH .. '" is '
              .. 'declared in "manifest.xml", but could not be found.'
            )
          end
        end
      end
      if thumbnail then
        if MANIFEST_THUMBNAIL_PATH == "" then
          print('Info: A "thumbnail.png" file was found but is not declared in '
            ..  '"manifest.xml."'
          )
        else
          local f = io.open("./" .. TOOL_FOLDER_NAME .. "/"
            .. MANIFEST_THUMBNAIL_PATH, "r"
          )
          if f ~= nil then
            io.close(f)
            print('Found thumbnail file "' .. MANIFEST_THUMBNAIL_PATH .. '".')
          else
            print('Warning: Thumbnail file "' .. MANIFEST_THUMBNAIL_PATH
              .. '" is declared in "manifest.xml", but could not be found.'
            )
          end
        end
      end
      if readme then
        if MANIFEST_DOCUMENTATION_PATH == "" then
          print('Info: A "readme.md" file was found but is not declared in '
            ..  '"manifest.xml".'
          )
        else
          local f = io.open("./" .. TOOL_FOLDER_NAME .. "/"
            .. MANIFEST_DOCUMENTATION_PATH, "r"
          )
          if f ~= nil then
            io.close(f)
            print('Found readme file "' .. MANIFEST_DOCUMENTATION_PATH .. '".')
          else
            print('Warning: Readme file "' .. MANIFEST_DOCUMENTATION_PATH
              .. '" is declared in "manifest.xml", but could not be found.'
            )
          end
        end
      end
      if license then
        if MANIFEST_LICENSE_PATH == "" then
          print('Info: A "license" file was found but is not declared in '
            ..  '"manifest.xml".'
          )
        else
          local f = io.open("./" .. TOOL_FOLDER_NAME .. "/"
            .. MANIFEST_LICENSE_PATH, "r"
          )
          if f ~= nil then
            io.close(f)
            print('Found license file "' .. MANIFEST_LICENSE_PATH .. '".')
          else
            print('Warning: License file "' .. MANIFEST_LICENSE_PATH
              .. '" is declared in "manifest.xml", but could not be found.'
            )
          end
        end
      end
      if preferences and CLEAN_PREFERENCES_XML then
        print("Deleting ./" .. TOOL_FOLDER_NAME .. "/preferences.xml")
        if OS == "WINDOWS" then
          -- windows del command doesn't like forward slashes
          local h = io.popen('"del ".\\' .. TOOL_FOLDER_NAME
            .. '\\preferences.xml\"'
          )
          if h ~= nil then
            h:flush()
            h:close()
          end
        elseif OS == "MACINTOSH" then
          -- todo
        elseif OS == "LINUX" then
          -- todo
        end
      end
      print('Copying the contents of ./' .. TOOL_FOLDER_NAME .. '/ to '
        .. RENOISE_PREFERENCES .. RENOISE_VERSION .. '/Scripts/Tools/'
        .. MANIFEST_ID .. '.xrnx'
      )
      if OS == "WINDOWS" then
        local h = io.popen('rmdir /Q /S "' .. RENOISE_PREFERENCES
          .. RENOISE_VERSION .. '/Scripts/Tools/' .. MANIFEST_ID
          .. '.xrnx" 2> nul'
        )
        if h ~= nil then
          h:flush()
          h:close()
        end
        h = io.popen('xcopy /s /e /h /i /y "./' .. TOOL_FOLDER_NAME .. '" "'
          .. RENOISE_PREFERENCES .. RENOISE_VERSION .. '/Scripts/Tools/'
          .. MANIFEST_ID .. '.xrnx"'
        )
        if h ~= nil then
          h:flush()
          for line in h:lines() do
            line = string.gsub(line, "\\", "/") 
            print(line)
          end
          h:close()
        end
      elseif OS == "MACINTOSH" then
        -- todo
      elseif OS == "LINUX" then
        -- todo
      end
      print('\nPacking the contents of ./' .. TOOL_FOLDER_NAME .. '/ to ./'
        .. OUTPUT_FOLDER_NAME .. '/' .. MANIFEST_ID .. '_v' .. MANIFEST_VERSION
        .. '.xrnx'
      )
      if OS == "WINDOWS" then
        local h = io.popen('md ' .. OUTPUT_FOLDER_NAME .. ' 2> nul')
        if h ~= nil then
          h:flush()
          h:close()
        end
        local f = io.open('./' .. OUTPUT_FOLDER_NAME .. '/' .. MANIFEST_ID
          .. '_v' .. MANIFEST_VERSION .. '.xrnx', "r"
        )
        if f ~= nil then
          io.close(f)
          -- windows del command doesn't like forward slashes
          h = io.popen('del ".\\' .. OUTPUT_FOLDER_NAME .. '\\' .. MANIFEST_ID
            .. '_v' .. MANIFEST_VERSION .. '.xrnx'
          )
          if h ~= nil then
            h:flush()
            h:close()
          end
        end
        h = io.popen('tar -acf "./' .. OUTPUT_FOLDER_NAME .. '/' .. MANIFEST_ID
          .. '_v' .. MANIFEST_VERSION .. '.zip" -v -C "./' .. TOOL_FOLDER_NAME
          .. '" *.*'
        )
        if h ~= nil then
          h:flush()
          h:close()
        end
        -- windows ren command doesn't like forward slashes
        h = io.popen('ren ".\\' .. OUTPUT_FOLDER_NAME .. '\\' .. MANIFEST_ID
          .. '_v' .. MANIFEST_VERSION .. '.zip" *.xrnx'
        )
        if h ~= nil then
          h:flush()
          h:close()
        end
      elseif OS == "MACINTOSH" then
        -- todo
      elseif OS == "LINUX" then
        -- todo
      end
    end
  end
  if not script_found and not tool_found then
    print('\nFolder "' .. SCRIPT_FOLDER_NAME .. '" or "' .. TOOL_FOLDER_NAME
      .. '" not found, nothing to do.\n'
    )
  end
end

-- todo?: start renoise

--[[-----------------------------------------------------------------[[ EOF ]]--
