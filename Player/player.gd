extends CharacterBody2D

"""
The @onready keyword ensures that all the nodes have been instantiated properly before we try to access them.
The Player sprite uses a Timer node for its walking animation.
"""

var movement_speed = 40.0
var hp = 80

# @onready variables are used to reference nodes and control their values
@onready var sprite = $Sprite2D # referencing node path using '$'
@onready var walkTimer = get_node("%walkTimer") # the node walkTimer is being accessed as a unique name and referenced using get_node()

# delta -> 1 second / framerate
# prevents the game from slowing down when the fps drops
# multiply movement with delta -> prevent the game from slowing down
# the speed of movement is recalculated for different framerates => no slowing down 
# move_and_slide() automatically uses delta within its calculations which is used in this project
func _physics_process(_delta): # _delta = saying "I don't want to use delta"
	movement()

func movement(): # checks what action is being pressed down
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left") # x_mov = 1 - 0 if 'right' key is being pressed and vice versa
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up") # y_mov = 1 - 0 if 'down' key is being pressed and vice versa
	var mov = Vector2(x_mov, y_mov) # movement direction -> (x,y) -> if x_mov=1, y_mov=0, then mov=Vector2(1x,0y) 
	
	 # flip the sprite horizontally to make it face the direction it is moving toward
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	# to move a CharacterBody2D object we need to set its velocity
	# velocity = Vector2(1x,0y)*40.0 = Vector2(40x,0y)
	# normalization -> takes each vector and divides it by the hypotenuse of a right-angled triangle 
	velocity = mov.normalized()*movement_speed # normalized() -> normalizing is to make sure that linear movement is just as fast as diagonal movement 
	move_and_slide() # this lets Godot know that we want the player sprite to move -> automatically uses delta within its calculations

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
