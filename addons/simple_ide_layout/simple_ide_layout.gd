"""
Main entry point for the plugin. 
Responsible for creating and managing the lifecycle of plugin modules.
"""
@tool
extends EditorPlugin

# Modules
var filesystem_panel_module: SIL_FilesystemPanelModule
var script_tabs_module: SIL_ScriptTabsModule


func _enter_tree() -> void:
	"""
	Called when the plugin is enabled or when the editor launches.
	"""
	var editor = EditorInterface.get_script_editor()
	var filesystem = EditorInterface.get_file_system_dock()
	
	filesystem_panel_module = SIL_FilesystemPanelModule.new(self, editor, filesystem)
	script_tabs_module = SIL_ScriptTabsModule.new(self, editor)
	
	filesystem_panel_module.enable()
	script_tabs_module.enable()


func _exit_tree() -> void:
	"""
	Called when the plugin is disabled or the editor shuts down.
	"""
	filesystem_panel_module.disable()
	script_tabs_module.disable()
