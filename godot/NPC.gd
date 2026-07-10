extends Area2D

@export var alreadyTalk: bool = false
#fazer que quando npc sair da tela, ativa denovo o alreadyTalk



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas":
		self.alreadyTalk = true
	#freeze game
	#faz o dialogo


#patricia
# HELP!						1
# HUEY HAS BEEN KIDNAPPED!	1

#huguinho
# THANKS UNCLE SCROOGE.		1
# GUESS WHAT. THIS			1
# HOUSE HAS AN				2
# ILLUSION WALL.			3

#skeleton key
# EUREKA!					1
# IT'S THE					1
# SKELETON KEY				1
# TO THE MINE.				2
