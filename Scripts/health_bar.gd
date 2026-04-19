extends ProgressBar

@warning_ignore("unused_parameter")

var parent
var max_value_amount
var min_value_amount

func _ready():
	parent = get_parent()
	max_value_amount = parent.health_max
	min_value_amount = parent.health_min
	
func _process(_delta):
	self.value = parent.health
	# Para que vea SIEMPRE
	self.visible = true

	if parent.health == min_value_amount:
		self.visible = false
