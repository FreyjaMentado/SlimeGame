extends RigidBody2D

signal slime_landed

enum side
{
	left,
	right,
	bottom
}

func _on_area_2d_body_entered_left(body):
	slime_landed.emit(self, side.left)


func _on_area_2d_body_entered_right(body):
	slime_landed.emit(self, side.right)


func _on_area_2d_body_entered_bottom(body):
	slime_landed.emit(self, side.bottom)
