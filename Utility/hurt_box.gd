extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

# signal: a built-in condition that can trigger a function in another script
# a node has many unique signals of its own and it also inherits signals from its parent
# we can also make custom signals
signal hurt(damage) # signal declaration -> using the `signal` keyword
# signal invocation -> using `emit_signal()` function (done below in this program)
# to connect a signal to the script -> Dock>Node>Signals -> double-click -> connect

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"): # -> hitbox -> when it enters the hurtbox
		if not area.get("damage") == null: # checking if there's a damage value associated with it
			match HurtBoxType: # gdscript version of switch-case
				0: #Cooldown
					collision.call_deferred("set","disabled",true) # disabled hurtbox collision
					disableTimer.start() # disabled for 0.5s (set in the inspector)
				1: #HitOnce
					pass # do nothing
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt",damage) # signal invocation -> using `emit_signal()` function

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set","disabled",false)
