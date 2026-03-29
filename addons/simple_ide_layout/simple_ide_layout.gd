@tool
extends EditorPlugin

var filesystem_data: FileSystemData
var editor: ScriptEditor
var side_panel: Control
var scripts_item_list: ItemList
var top_vbox: VBoxContainer

var _invisible_parent: Control


#region DTO
class FileSystemData extends Resource:
	var filesystem: FileSystemDock
	var original_parent: Node
	var original_index: int
	
	func _init(_filesystem, _original_parent, _original_index) -> void:
		filesystem = _filesystem
		original_parent = _original_parent
		original_index = _original_index
#endregion


func _enter_tree() -> void:
	editor = EditorInterface.get_script_editor()
	filesystem_data = _get_filesystem_data()
	side_panel = _get_side_panel()
	top_vbox = _get_top_vbox()
	
	_invisible_parent = _init_invisible_parent()
	
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	
	for child in side_panel.get_children():
		child.reparent(_invisible_parent)
	
	
	scripts_item_list = _find_scripts_item_list(_invisible_parent)
	
	if scripts_item_list:
		scripts_item_list.reparent(top_vbox)
		scripts_item_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		scripts_item_list.custom_minimum_size.y = 48
		scripts_item_list.auto_height = true
		scripts_item_list.max_columns = 12
		
		# Move to the top of container
		top_vbox.move_child(scripts_item_list, 1)
	
	main_screen_changed.connect(_on_main_screen_changed)
	
	_move_filesystem_to_editor()


func _exit_tree() -> void:
	if _invisible_parent:
		for child in _invisible_parent.get_children():
			child.reparent(side_panel)
	
	_invisible_parent.queue_free()
	_reset_filesystem_position()



func _find_scripts_item_list(root: Node) -> ItemList:
	var lists = root.find_children("*", "ItemList", true, false)
	
	if lists.is_empty():
		return null
	
	return lists[0]


func _move_filesystem_to_editor() -> void:
	if not filesystem_data:
		return

	_invisible_parent.visible = false
	
	var filesystem = filesystem_data.filesystem
	filesystem.reparent(side_panel)
	side_panel.move_child(filesystem, 0)


func _reset_filesystem_position() -> void:
	if not filesystem_data:
		return

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
		filesystem.get_index()
	)


func _get_side_panel() -> Control:
	var splits = editor.find_children("*", "HSplitContainer", true, false)
	if splits.is_empty():
		return null
	
	return splits[0].get_child(0)


func _get_top_vbox() -> VBoxContainer:
	var editor_root = EditorInterface.get_script_editor()
	var vboxes = editor_root.find_children("*", "VBoxContainer", true, false)
	
	return editor_root.get_child(0)


func _init_invisible_parent() -> Control:
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
