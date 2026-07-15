extends CharacterBody2D

var canIPogoAndAttack: bool

func _ready() -> void:
	$AnimatedSprite2D.play("closed")
	
	self.canIPogoAndAttack = $"..".canIPogoAndAttack

func desactiveChest() -> void:
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(.1).timeout
	$".".visible = false
	$AnimatedSprite2D.play("empty")
	$CollisionShape2D.disabled = true
	$"..".active_from_chest()
