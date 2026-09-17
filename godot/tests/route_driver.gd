extends RefCounted
## Fixed input route through the real level. No position/velocity edits.
## 936/1048/1168 are the walker-jumpman-yuan Zone 3 additions: the gap onto
## the first elevated landing, the full-speed jump that clears the second
## landing's spike in one arc, then the final gap onto the relocated finish.
var jump_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 936.0, 1048.0, 1168.0]
var next_jump: int = 0

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_axis = 1.0
	player.test_jump_held = false
	if next_jump < jump_marks.size() and player.position.x >= jump_marks[next_jump] and player.is_on_floor():
		player.test_jump_pressed = true
		next_jump += 1
