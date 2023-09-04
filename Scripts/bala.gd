extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_area_entered(area):
	if area.is_in_group("inimigo"):
		area.vida -= 1
		area.get_node("AnimationPlayer").play("dano")
		if area.vida == 0:
			area.morre()
		queue_free()
