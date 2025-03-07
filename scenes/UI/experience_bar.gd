extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	experience_manager.experience_updated.connect(on_experience_updated)
	progress_bar.value = 0
	

func on_experience_updated(current_experience: float, target_experience: float):
	if progress_bar == null:
		return
	var percent = current_experience/target_experience
	progress_bar.value = percent
