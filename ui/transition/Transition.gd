extends CanvasLayer


signal blackout


var reversed = false


func _ready():
	match (reversed):
		true:
			$ColorRect.set_modulate(ColorManager.previous_color.background)
			$ColorRect/AnimationPlayer.play("FadeOut")
		false:
			$ColorRect.set_modulate(ColorManager.color.background)
			$ColorRect/AnimationPlayer.play("FadeIn")


func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"FadeIn":
			emit_signal("blackout")
			$ColorRect/AnimationPlayer.play("FadeOut")
		"FadeOut":
			queue_free()
