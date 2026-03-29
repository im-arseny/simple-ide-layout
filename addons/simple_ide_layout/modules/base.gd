"""
Base class for the plugins modules. Any module should be 
independent from other modules and guarantee that it's functionality
will be reverted once disabled.
"""
@tool
extends Node
class_name SIL_BaseModule


func enable() -> void:
	"""
	Enable module. Start of the module lifetime
	"""
	# Setup all the changes that the module presents
	pass


func disable() -> void:
	"""
	Disable module. End of the module lifetime
	"""
	# Revert all the changes made by the module
	pass
