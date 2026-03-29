@tool
extends SIL_BaseModule
class_name SIL_FilesystemPanelModule

var editor: ScriptEditor
var plugin: EditorPlugin

var side_panel: Control
var filesystem_data: SIL_FileSystemDataDTO

var _temporal_parent: Control


func _init(plugin: EditorPlugin, editor: ScriptEditor, filesystem: FileSystemDock) -> void:
	self.plugin = plugin
	self.editor = editor
	self.filesystem_data = _get_filesystem_data(filesystem)


func enable() -> void:
	"""
	Enable FileSystem render in the ScriptEditor's side panel
	"""
	side_panel = _get_side_panel()
	_temporal_parent = _init_temporal_parent()

	if not side_panel:
		return push_error("Failed to add FileSystem node to side panel: SidePanel not found")
	
	for child in side_panel.get_children():
		child.reparent(_temporal_parent)
	
	plugin.main_screen_changed.connect(_on_main_screen_changed)


func disable() -> void:
	"""
	Move FileSystem to its previous position and revert all changes
	"""
	if not _temporal_parent:
		return push_warning("Couldn't found temporal side panel container, disabling silently")

	for child in _temporal_parent.get_children():
		child.reparent(side_panel)
	
	_temporal_parent.queue_free()


func _move_filesystem_to_editor() -> void:
	"""
	Move FileSystem inside the EditorScripts side panel
	"""
	if not filesystem_data:
		return

	_temporal_parent.visible = false
	
	var filesystem = filesystem_data.filesystem
	filesystem.reparent(side_panel)
	side_panel.move_child(filesystem, 0)


func _reset_filesystem_position() -> void:
	"""
	Revert FileSystem back to its previous position
	"""
	if not filesystem_data:
		return

	_temporal_parent.visible = true
	
	var filesystem = filesystem_data.filesystem
	filesystem.reparent(filesystem_data.original_parent)
	filesystem_data.original_parent.move_child(
		filesystem,
		filesystem_data.original_index
	)


func _get_filesystem_data(filesystem: FileSystemDock) -> SIL_FileSystemDataDTO:
	"""
	Construct the DTO that contains all necessary data about FileSystem
	"""
	return SIL_FileSystemDataDTO.new(
		filesystem,
		filesystem.get_parent(),
		filesystem.get_index()
	)


func _get_side_panel() -> Control:
	"""
	Get side panel node
	"""
	var splits = self.editor.find_children("*", "HSplitContainer", true, false)
	if splits.is_empty():
		return null
	
	return splits[0].get_child(0)


func _init_temporal_parent() -> Control:
	"""
	Setup and return temporal parent for side panel contents.
	Mostly needed because you can't simply hide 
	all the contents via 'visible' property.
	"""
	var invisible_parent = Control.new()
	invisible_parent.name = "InvisibleParent"
	invisible_parent.visible = false
	
	side_panel.get_parent().add_child(invisible_parent)
	return invisible_parent


func _on_main_screen_changed(screen_name: String) -> void:
	if screen_name == "Script":
		_move_filesystem_to_editor()
	else:
		_reset_filesystem_position()
