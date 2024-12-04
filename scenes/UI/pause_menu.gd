extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")

var isClosing = false

func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size/2
	
	resume_button.pressed.connect(on_resume_pressed_signal)
	options_button.pressed.connect(on_options_pressed_signal)
	quit_button.pressed.connect(on_quit_pressed_signal)
	
	animation_player.play("default")
	var tween = create_tween()
	# Properly set the comntianer to zero before we start scaling it to 1
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()
		# tell godot the input has been handled
		get_tree().root.set_input_as_handled()
	
func close():
	if isClosing:
		return
	isClosing = true
	# play default animation backwards
	animation_player.play_backwards("default")
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, .0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		
	await tween.finished
	get_tree().paused = false
	queue_free()
	

func on_resume_pressed_signal():
	close()
	
func on_options_pressed_signal():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed_signal.bind(options_instance))
	
func on_options_closed_signal(options_instance: Node):
	options_instance.queue_free()

func on_quit_pressed_signal():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
