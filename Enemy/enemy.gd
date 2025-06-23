extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10

# @onready var -> gets a value after the nodes are loaded.
# We use @onready var to reference nodes.
@onready var player = get_tree().get_first_node_in_group("player")  # get_tree() -> parent to the World node -> highest/root node
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("walk")

func _physics_process(_delta): # _delta = saying "I don't want to use delta"
	var direction = global_position.direction_to(player.global_position) # global_position -> position wrt the tree
	#print(direction)
	velocity = direction*movement_speed
	move_and_slide() # this lets Godot know that we want the enemy to move
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	if hp<=0:
		queue_free()
