extends RayCast3D

var current_obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if is_colliding():
		var object = get_collider()
		if object == current_obj:
			return
		else:
			current_obj = object
	else:
		current_obj = null
