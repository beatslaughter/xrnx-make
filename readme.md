# XRNX Make

Developer utility for installing and packaging Renoise tools.

![Example integration with Visual Studio Code](/images/vscode.png)

## Introduction

**XRNX-MAKE** is a small command-line script written in Lua to ease the development of Renoise tools outside of the internal Scripting Editor, for example in Visual Studio Code. It distributes your files from your project folder into your Renoise installation and creates a versioned *.xrnx file for distribution, adding sort of a compiling step to your project.

To avoid relying on any additional Lua libraries, it spawns various command-line tools for its tasks. At the time of writing, only Windows support is included, but placeholders for Macintosh and Linux are in place. This script requires Lua to be accessible from your command-line.

>Any uppercase variables inside the script can be customized, there are also descriptions available inside the file.

## How it works in detail

Create a folder for your project anywhere you like and copy **xrnx-make.lua** into the folder. Open the Lua script and adjust the uppercase variables at the top for proper generation of a **manifest.xml** file. You can also customize a few options, like the names of the folders this script uses or target a specific Renoise version.

The script supports Renoise tools, but also Renoise terminal scripts. If you want to create a tool, then create a subfolder **"tool"**, which will hold any of your tool files. If you want to create a terminal script, then create a folder **"script"**. You can also have both folders active at the same time. Any additional folders you create inside the project folder will be ignored by the script. Upon successful packaging of your tool, you'll find a newly created **"out"** folder containing the *.xrnx file with your tool version number appended.

Your project folder tree looks like this then:  
  
    [my-project]
    ├ [out]    - contains *.xrnx files
    ├ [script] - contains terminal scripts
    ├ [tool]   - contains all the files of your tool
    └ xrnx-make.lua

Once you have your project folders in place and customized all the various manifest.xml options, you can run the script. Here is a detailed breakdown of what it does:

- Look for a folder with the name **"script"** and copy the content into the Renoise user scripts folder, while overwriting any existing files with the same name.

- Look for a folder with the name **"tool"**, install the content into the Renoise user tools folder, while also removing an old existing installation of your tool and then package a *.xrnx file into the **"out"** folder inside your projects folder, overwriting a file with the same version number.

- If the **"tool"** folder contains a **"preferences.xml"** file, then it will be deleted so it's not distributed inside your tool. This behavior can be customized.

- If no **"main.lua"** is found, then the script will generate a basic file as a starting point. The **"manifest.xml"** file will always be written, so be careful to only customize any options inside the script and not directly in the XML file.

- There is some additional checks for the optional files **"cover.png"**, **"thumbnail.png"**, **"readme.md"** and the **"license"** file.
<br>
<br>
>Additional reference:<br>
>https://renoise.github.io/xrnx/start/tool.html

>The "json" folder contains an example integration into Visual Studio Code using the Favorites panel extension, as seen in the picture:<br>
>https://marketplace.visualstudio.com/items?itemName=sabitovvt.favorites-panel
