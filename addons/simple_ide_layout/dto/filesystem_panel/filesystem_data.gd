extends Resource
class_name SIL_FileSystemDataDTO

var filesystem: FileSystemDock
var original_parent: Node
var original_index: int


func _init(_filesystem, _original_parent, _original_index) -> void:
	filesystem = _filesystem
	original_parent = _original_parent
	original_index = _original_index
