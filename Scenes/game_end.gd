extends Area3D
@onready var player_controller: PlayerController = $"../PlayerController"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body == player_controller:
		get_tree().change_scene_to_file("res://Scenes/Win.tscn")
		print("aosidhfaoisd")

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	#get_tree().change_scene_to_file("res://Scenes/Win.tscn")
	pass

func _on_area_entered(area: Area3D) -> void:
	#get_tree().change_scene_to_file("res://Scenes/Win.tscn")
	pass
