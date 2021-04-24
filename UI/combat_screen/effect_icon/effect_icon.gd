extends TextureRect

var effect
var duration


func _process(delta):
	$TimeProgress.value = ($Timer.time_left / duration) * 100


func initialize(_effect):
	effect = _effect
	$TextureRect.texture = load(effect.image_path)
	duration = effect.duration
	$Timer.wait_time = duration
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
