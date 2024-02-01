extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(750.0, 3000.0) var thrust: float =1000.0

## yes it is somethin
@export var torque_trust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var sucess_audio: AudioStreamPlayer = $SucessAudio


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Boost"):
		apply_central_force(basis.y  * delta * thrust)
		
	if Input.is_action_pressed("Rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_trust * delta))
	
	if Input.is_action_pressed("Rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_trust * delta))
 
func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_levet(body.file_path)
			
		if "Hazard" in body.get_groups():
			crash_sequences()
			
func crash_sequences() -> void:
	print("BOOM!")
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5) 
	tween.tween_callback(get_tree().reload_current_scene)
	
func complete_levet(next_level_file: String) ->void:
	print("You win!")
	sucess_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
	
	
	
