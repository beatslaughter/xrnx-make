# XRNX Make

Developer utility for installing and packaging Renoise tools.

![Example integration with Visual Studio Code](/images/vscode.png)

## Introduction

XRNX-MAKE is a little command line script written in Lua to ease the development of Renoise tools outside of the internal Scripting Editor, for example in Visual Studio Code. It will distribute your files from your project folder into your Renoise installation and create a versioned *.xrnx file for distribution, adding something like a compiling step for your project.

To not rely on any additional Lua libraries it spawns various command line tools for the tasks, but at the time of writing only Windows support is included. Placeholders to further support Macintosh and Linux are in place.

>Any uppercase variable inside the script can be customized, there is also descriptions available inside the file. 

## How it works in detail

Create a folder for your project anywhere you like and copy xrnx-make.lua into the folder. Open the Lua script and adjust the uppercase variables at the top for proper generation of a manifest.xml required by Renoise tools. You can also customize a few options like the names of the folders this script uses.

The script supports Renoise tools, but also Renoise terminal scripts. If you want to create a tool, then create a subfolder "tool", which will hold any of your tool files. If you want to create a terminal script, then create a folder "script". You can also have both folders active at the same time. Any additional folders you create inside the project folder will be ignored by the script. Upon successful packaging of your tool, you'll find an "out" folder containing the *.xrnx file.

Your project folder tree looks like this then:  
  
**[my-project]**<br>
**├ [out]** - contains versioned *.xrnx files<br>
**├ [script]** - the content of this folder will be copied into the Renoise Scripts folder<br>
**├ [tool]** - the content of this folder will be installed as a tool into Renoise and then packaged<br>
**└ xrnx-make.lua**<br>

Once you have your project folders in place and customized all the various manifest.xml options, you can run the script. Here is a detailed breakdown of what it does:

- Look for a folder with name "script" and copy the content into Renoise overwriting any existing files with the same name.

- Look for a folder with name "tool", install the content into Renoise removing an old existing installation of your tool and package a *.xrnx file into the "out" folder, overwriting a file with the same version number.

- If the "tool" folder contains a "preferences.xml" file, then it will be deleted, so it's not distributed inside your tool. This behavior can be customized.

- If no "main.lua" is found the script will generate a basic one as a starting point. The "manifest.xml" file will always be written, so only customize any options inside the script and not directly in the XML file.

- There is some additional checks for cover.png, thumbnail.png, readme.md and the license file.

<br><br>

>Additional reference: https://renoise.github.io/xrnx/start/tool.html

>The "json" folder contains an example integration into Visual Studio Code using the Favorites panel extension, as seen in the picture:
>
>https://marketplace.visualstudio.com/items?itemName=sabitovvt.favorites-panel



