class_name Heart extends TextureRect

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func make_critical():
	sprite.play("low_hp")

func make_not_critical():
	sprite.play("default")
