extends RichTextLabel

# Dictionary mapping characters to your image paths
const IMAGE_MAP = {
	"0": "res://0.png",
	"1": "res://1.png",
	"2": "res://2.png",
	"3": "res://3.png",
	"4": "res://4.png",
	"5": "res://5.png",
	"6": "res://6.png",
	"7": "res://7.png",
	"8": "res://8.png",
	"9": "res://9.png"
}

# This variable holds the number. Changing it automatically updates the UI.
var current_value: int = 60:
	set(value):
		current_value = value
		_update_image_display()

func _ready() -> void:
	# Initialize the display with the starting value
	_update_image_display()

# This handles the actual responsive conversion
func _update_image_display() -> void:
	var bbcode_result = ""
	var string_value = str(current_value) # Convert the integer to a string (e.g., 60 to "60")
	
	for character in string_value:
		if IMAGE_MAP.has(character):
			bbcode_result += "[img]" + IMAGE_MAP[character] + "[/img]"
		else:
			bbcode_result += character
			
	text = bbcode_result
