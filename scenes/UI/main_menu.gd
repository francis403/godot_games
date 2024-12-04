extends CanvasLayer

var options_scene = preload("res://scenes/UI/options_menu.tscn")
var meta_menu_scene = preload("res://scenes/UI/meta_menu.tscn")

@onready var meta_menu: Button = %MetaMenu

func _ready() -> void:
	$"%PlayButton".pressed.connect(on_play_pressed_signal)
	$"%OptionsButton".pressed.connect(on_options_pressed_signal)
	$"%QuitButton".pressed.connect(on_quit_pressed_signal)
	meta_menu.pressed.connect(on_meta_menu_pressed_signalon)


func on_play_pressed_signal():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed_signal():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed_signal.bind(options_instance))


func on_quit_pressed_signal():
	get_tree().quit()

func on_options_closed_signal(options_instance: Node):
	options_instance.queue_free()
	
func on_meta_menu_pressed_signalon():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var meta_menu_instance = meta_menu_scene.instantiate()
	add_child(meta_menu_instance)
	meta_menu_instance.back_button_pressed.connect(\
		on_meta_menu_back_button_pressed_signal.bind(meta_menu_instance)\
	)
	# meta_menu_instance.back_pressed.connect(on_options_closed_signal.bind(options_instance))

func on_meta_menu_back_button_pressed_signal(meta_menu_instance: Node):
	meta_menu_instance.queue_free()
