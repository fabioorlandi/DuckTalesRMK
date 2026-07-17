extends Area2D

@export var alreadyTalk: bool = false
#fazer que quando npc sair da tela, ativa denovo o alreadyTalk

@export var patricia: bool
@export var huguinho: bool

func _process(delta: float) -> void:
	if alreadyTalk == true and $"../../Camera2D/UI/Talk_Right/Label".alreadyWrite == true and Input.is_action_just_pressed("jump"):
		$"../../Camera2D/UI/Talk_Right/Label".alreadyWrite = false
		get_tree().paused = false
		$"../../Camera2D/UI/Talk_Right/Label".type_text("")
		$"../../Camera2D/UI".ShowInGameUI()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Patinhas" and alreadyTalk == false:
		self.alreadyTalk = true
		get_tree().paused = true
		$"../../Camera2D/UI".ShowMessage()
		if patricia:
			$"../../Camera2D/UI/Talk_Right/Label".type_text("HELP! HUEY HAS BEEN KIDNAPPED!")
		if huguinho:
			$"../../Camera2D/UI/Talk_Right/Label".type_text("THANKS UNCLE SCROOGE. GUESS WHAT. THIS HOUSE HAS AN ILLUSION WALL")
		
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
