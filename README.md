# Simple IDE Layout - for Godot 4.6+

Changes the Godot Script Editor layout to be more in line with modern IDEs.
Adds features such as a Git gutter.
<img width="1633" height="1078" alt="image" src="https://github.com/user-attachments/assets/36b48fdf-9dea-48c8-9234-a141ed1c1065" />

# How to Install
- Download the repository from GitHub and place the `addons` folder in your project. Then enable it in the Project Settings.
- Hide or move the `History` tab to a different location.
- You can find the plugin options in the Editor Settings with Advanced Settings enabled.

# Features

### FileSystem inside ScriptEdtior
Replaces default side panel in ScriptEditor with the FileSystem Dock, making it look like layout of more modern and advanced IDEs. FileSystem is fully functional and returns back to default dock position whenever you swtich from "Script" tab.

### File tabs above the ScriptEditor
Replacing side panel makes file list disappear, so we moved this part of the UI above the ScriptEditor, again following most modern IDE layout philosophy.

# To Do
- [ ] Update FileSystem default parent and index when it's moved by user

# License

This project is licensed under the MIT License. See the
[LICENSE](addons/simple_ide_layout/LICENSE.txt) file for details.

## Third-party code

The tab bar and split original logic were derived from the Script IDE add-on
by Marius Hanl and are used under the MIT License.
