@tool
extends Node2D

const DISTANCE_BETWEEN_FRAGMENTS = 15

@export var hook_length: int = 4:
	set(new_value):
		hook_length = new_value
		_initialize_grappling_fragments()

var hook_fragment = preload("res://grappling-hook/HookFragment.tscn")

func _initialize_grappling_fragments():
	delete_children(self)
	var prev_hook: Node2D = null
	for i in range(hook_length):
		var new_hook: Node2D = hook_fragment.instantiate()
		if (prev_hook):
			new_hook.transform.origin.x = prev_hook.transform.origin.x + DISTANCE_BETWEEN_FRAGMENTS
		
		self.add_child(new_hook)
		if Engine.is_editor_hint(): 
			new_hook.set_owner(get_tree().get_edited_scene_root())
		prev_hook = new_hook
	
	for i in range(hook_length):
		if i < self.get_child_count() - 1:
			var child = self.get_child(i)
			var next_child = self.get_child(i + 1)
			if next_child && next_child.is_inside_tree():
				child.neighbour_fragment = next_child.get_path()

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _ready():
	_initialize_grappling_fragments()
