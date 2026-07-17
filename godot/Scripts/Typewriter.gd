extends Label

var _typing_id: int = 0

@export var alreadyWrite: bool = false

func type_text(full_text: String, char_delay: float = 0.05) -> void:
	_typing_id += 1
	var my_id = _typing_id

	text = ""

	for i in range(full_text.length()):
		if my_id != _typing_id:
			return

		text += full_text[i]

		if char_delay > 0.0:
			await get_tree().create_timer(char_delay).timeout

	if my_id == _typing_id:
		alreadyWrite = true

func skip_typing(full_text: String) -> void:
	_typing_id += 1
	text = full_text
