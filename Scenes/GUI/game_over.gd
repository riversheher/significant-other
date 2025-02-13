extends CanvasLayer


@onready var text: Label = $Description

var endings: Array[String] = [
	"River squeezed you too hard because her love was overflowing.",
	"River kissed you but then infected you with the chinese virus and turned you into a chinese spy.",
	"River kissed you with fish in her mouth.",
	"River went non-verbal and you couldn't understand her so she got mad and killed you.",
	"River got too horny and dry humped you until you had a heart attack.",
	"You said 'secure boot the github' one too many times",
	"You pushed river away and off the bed last night so she has come to take her revenge"
]

func _ready() -> void:
	AudioPlayer.stop()
	
	text.text = endings[randi() % (endings.size())]

func _on_retry_pressed() -> void:
	LevelManager.to_retry()


func _on_quit_pressed() -> void:
	get_tree().quit(0)
