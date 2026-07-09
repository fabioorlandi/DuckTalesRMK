extends Area2D

@export var alreadyTalk: bool = false
#fazer que quando npc sair da tela, ativa denovo o alreadyTalk



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		self.alreadyTalk = true
	#freeze game
	#faz o dialogo
