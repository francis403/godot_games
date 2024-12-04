extends AudioStreamPlayer


func _ready():
	finished.connect(on_finished_signal)
	$Timer.timeout.connect(on_timer_timeout)


func on_finished_signal():
	$Timer.start()
	
func on_timer_timeout():
	play()
