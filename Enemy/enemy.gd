extends CharacterBody2D
"""
if parent.position = Vector2(0x,0y) -> child.position = child.global_position
if parent.position = Vector2(100x,0y) -> child.position = child.position + parent.position
direction_to(...) -> uses normalized() by default
The Enemy sprite uses an AnimationPlayer node for its walking animation.
"""

# @export variables lets us edit their values in the inspector
@export var movement_speed = 20.0
@export var hp = 10

# @onready var -> gets a value after the nodes are loaded.
# We use @onready var to reference nodes.
#To add a group: click on the scene -> Dock (if closed, go to Editor -> Editor Docks) -> Node -> Groups
@onready var player = get_tree().get_first_node_in_group("player") # get_tree() -> parent to the World node -> highest/root node
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _ready(): # runs at the start, only once 
	anim.play("walk") # playing the walk animation

func _physics_process(_delta): # _delta = saying "I don't want to use delta"
	var direction = global_position.direction_to(player.global_position) # global_position -> position wrt the tree
	#print(direction)
	velocity = direction*movement_speed
	move_and_slide() # this lets Godot know that we want the enemy sprite to move -> automatically uses delta within its calculations
	
	# flip the sprite horizontally to make it face the direction it is moving toward
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	if hp<=0:
		queue_free() # destroys a node safely at the end of the frame and also removes it from the tree
