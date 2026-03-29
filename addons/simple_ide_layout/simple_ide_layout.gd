@tool
extends EditorPlugin

var filesystem_data: FileSystemData
var editor: ScriptEditor
var side_panel: VSplitContainer

var _invisible_parent: Control


#region DTO
class FileSystemData extends Resource:
	var filesystem: FileSystemDock
	var original_parent: Node
	var original_index: int
	
	func _init(
		_filesystem: FileSystemDock, 
		_original_parent: Node, 
		_original_index: int
	) -> void:
		self.filesystem = _filesystem
		self.original_parent = _original_parent
		self.original_index = _original_index
#endregion


func _enter_tree() -> void:
	filesystem_data = _get_filesystem_data()
	
	editor = EditorInterface.get_script_editor()
	side_panel = _get_side_panel()
	_invisible_parent = _init_invisible_parent()
	for child in side_panel.get_children():
		child.reparent(_invisible_parent)
	
	main_screen_changed.connect(_on_main_screen_changed)
	
	_move_filesystem_to_editor()


func _exit_tree() -> void:
	for child in _invisible_parent.get_children():
		child.reparent(side_panel)
	
	_reset_filesystem_position()
	
	_invisible_parent.queue_free()


func _move_filesystem_to_editor() -> void:
	_invisible_parent.visible = false
	
	var filesystem = filesystem_data.filesystem
	filesystem.reparent(side_panel)
	side_panel.move_child(filesystem, 0)


func _reset_filesystem_position() -> void:
	_invisible_parent.visible = true
	
	var filesystem = filesystem_data.filesystem
	filesystem.reparent(filesystem_data.original_parent)
	filesystem_data.original_parent.move_child(
		filesystem, 
		filesystem_data.original_index
	)



func _get_filesystem_data() -> FileSystemData:
	var filesystem = EditorInterface.get_file_system_dock()
	
	return FileSystemData.new(
		filesystem,
		filesystem.get_parent(),
		filesystem.get_index(),
	)


func _get_side_panel() -> Control:
	var editor_split = editor.find_children("*", "HSplitContainer", true, false)[0]
	return editor_split.get_child(0)


func _init_invisible_parent() -> Control:
	var invisible_parent = Control.new()
	side_panel.get_parent().add_child(invisible_parent)
	invisible_parent.visible = false
	return invisible_parent


func _on_main_screen_changed(screen_name: String) -> void:
	if screen_name == "Script":
		_move_filesystem_to_editor()
	else:
		_reset_filesystem_position()
