extends Area2D

@export var alreadyTalk: bool = false
#fazer que quando npc sair da tela, ativa denovo o alreadyTalk

@export var entrou_na_tela: bool = false

@export var margem_de_exclusao: float = 220.0

func _process(delta: float) -> void:
	var pos = $"../../Patinhas".global_position
	
	# Verifica se afastou demais do player
	if pos.x < global_position.x - margem_de_exclusao or pos.x > global_position.x + margem_de_exclusao:	   
		alreadyTalk = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and !alreadyTalk:
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
