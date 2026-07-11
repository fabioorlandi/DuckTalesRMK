extends RichTextLabel

# Dictionary mapping characters to your image paths
const IMAGE_MAP = {
	"0": "res://Assets_Font_UI/0.png",
	"1": "res://Assets_Font_UI/1.png",
	"2": "res://Assets_Font_UI/2.png",
	"3": "res://Assets_Font_UI/3.png",
	"4": "res://Assets_Font_UI/4.png",
	"5": "res://Assets_Font_UI/5.png",
	"6": "res://Assets_Font_UI/6.png",
	"7": "res://Assets_Font_UI/7.png",
	"8": "res://Assets_Font_UI/8.png",
	"9": "res://Assets_Font_UI/9.png",
	"a": "res://Assets_Font_UI/a.png",
	"b": "res://Assets_Font_UI/b.png",
	"c": "res://Assets_Font_UI/c.png",
	"d": "res://Assets_Font_UI/d.png",
	"e": "res://Assets_Font_UI/e.png",
	"f": "res://Assets_Font_UI/f.png",
	"g": "res://Assets_Font_UI/g.png",
	"h": "res://Assets_Font_UI/h.png",
	"i": "res://Assets_Font_UI/i.png",
	"j": "res://Assets_Font_UI/j.png",
	"k": "res://Assets_Font_UI/k.png",
	"l": "res://Assets_Font_UI/l.png",
	"m": "res://Assets_Font_UI/m.png",
	"n": "res://Assets_Font_UI/n.png",
	"o": "res://Assets_Font_UI/o.png",
	"p": "res://Assets_Font_UI/p.png",
	"q": "res://Assets_Font_UI/q.png",
	"r": "res://Assets_Font_UI/r.png",
	"s": "res://Assets_Font_UI/s.png",
	"t": "res://Assets_Font_UI/t.png",
	"u": "res://Assets_Font_UI/u.png",
	"v": "res://Assets_Font_UI/v.png",
	"w": "res://Assets_Font_UI/w.png",
	"x": "res://Assets_Font_UI/x.png",
	"y": "res://Assets_Font_UI/y.png",
	"z": "res://Assets_Font_UI/z.png",

	"!": "res://Assets_Font_UI/!.png",
	"'": "res://Assets_Font_UI/apostrofe.png",
	"/": "res://Assets_Font_UI/slash.png",
	".": "res://Assets_Font_UI/dot.png",
	"$": "res://Assets_Font_UI/cifrao.png",
	"©": "res://Assets_Font_UI/copyright.png"
}

# This variable holds the number. Changing it automatically updates the UI.
var current_value: String = "aspas":
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
