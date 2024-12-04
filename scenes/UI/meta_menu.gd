extends CanvasLayer

signal  back_button_pressed

@export var upgrades: Array[MetaUpgrade]

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

var meta_upgrade_card_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")


func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed_signal)
	clean_test_grid_items()
	instantiate_meta_upgrades()

func clean_test_grid_items():
	for item in grid_container.get_children():
		item.queue_free()

func instantiate_meta_upgrades():
	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)

# Signals
func on_back_button_pressed_signal():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_button_pressed.emit()
