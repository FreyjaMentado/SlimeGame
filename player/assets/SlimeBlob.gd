extends RigidBody2D

signal slime_landed

func _on_area_2d_body_entered(body):
	slime_landed.emit(self)
	
