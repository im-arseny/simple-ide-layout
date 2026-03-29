extends SIL_BaseModule
class_name SIL_ScriptTabsModule

var editor: ScriptEditor

var scripts_item_list: ItemList
var top_vbox: VBoxContainer


func _init(plugin: EditorPlugin, editor: ScriptEditor) -> void:
	self.plugin = plugin
	self.editor = editor


func enable() -> void:
	top_vbox = _get_top_vbox()
	
	scripts_item_list = _find_scripts_item_list(editor)
	
	if scripts_item_list:
		scripts_item_list.reparent(top_vbox)
		scripts_item_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		scripts_item_list.custom_minimum_size.y = 48
		scripts_item_list.auto_height = true
		scripts_item_list.max_columns = 12
		
		# Move to the top of container
		top_vbox.move_child(scripts_item_list, 1)


func disable() -> void:
	pass


func _find_scripts_item_list(root: Node) -> ItemList:
	var lists = root.find_children("*", "ItemList", true, false)
	
	if lists.is_empty():
		return null
	
	return lists[0]


func _get_top_vbox() -> VBoxContainer:
	var editor_root = EditorInterface.get_script_editor()
	var vboxes = editor_root.find_children("*", "VBoxContainer", true, false)
	
	return editor_root.get_child(0)
