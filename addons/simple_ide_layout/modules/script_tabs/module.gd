extends SIL_BaseModule
class_name SIL_ScriptTabsModule

var plugin: EditorPlugin
var editor: ScriptEditor

var scripts_item_list: ItemList
var top_vbox: VBoxContainer

var defaults : Dictionary[StringName, Variant]

func _init(plugin: EditorPlugin, editor: ScriptEditor) -> void:
	self.plugin = plugin
	self.editor = editor


func enable() -> void:
	top_vbox = _get_top_vbox()
	
	scripts_item_list = _find_scripts_item_list(editor)
	
	if scripts_item_list:
		defaults[&"parent"] = scripts_item_list.get_parent()
		defaults[&"size_flags_vertical"] = scripts_item_list.size_flags_vertical
		defaults[&"custom_minimum_size:y"] = scripts_item_list.custom_minimum_size.y
		defaults[&"auto_height"] = scripts_item_list.auto_height
		defaults[&"max_columns"] = 0
		
		scripts_item_list.reparent(top_vbox)
		scripts_item_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		scripts_item_list.custom_minimum_size.y = 48
		scripts_item_list.auto_height = true
		scripts_item_list.max_columns = 32
		
		# Move to the top of container
		top_vbox.move_child(scripts_item_list, 1)


func disable() -> void:
	if scripts_item_list:
		if defaults[&"parent"]:
			scripts_item_list.reparent(defaults[&"parent"])
		
		for key in defaults.keys():
			if key == &"parent":
				continue
			
			scripts_item_list.set(key, defaults[key])


func _find_scripts_item_list(root: Node) -> ItemList:
	var lists = root.find_children("*", "ItemList", true, false)
	
	if lists.is_empty():
		return null
	
	return lists[0]


func _get_top_vbox() -> VBoxContainer:
	var editor_root = EditorInterface.get_script_editor()
	var vboxes = editor_root.find_children("*", "VBoxContainer", true, false)
	
	return editor_root.get_child(0)
