extends SceneTree
## Visual evidence for CHANGE-BRIEF.md failure case 1: does the new Crate-Bot
## silhouette read sensibly against its unchanged 18x28 collider, left/right/
## standing/jumping? Renders the real viewport; not a claim of human judgment.
const Game = preload("res://game/session.gd")
var game: Node2D
var output: String

func _initialize() -> void:
	call_deferred("run")

func step() -> void:
	await physics_frame
	await process_frame

func capture(label: String) -> void:
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(output + "/" + label + ".png")
	assert(error == OK)
	print("Captured rendered game viewport: " + label)

func run() -> void:
	output = ProjectSettings.globalize_path("res://../evidence/screens")
	DirAccess.make_dir_recursive_absolute(output)
	game = Game.new()
	game.test_mode = true
	root.add_child(game)
	for i in range(3): await step()
	game.start_session()
	game.player.test_control = true

	# Facing right, standing still, next to the near wall of a solid so the
	# collider edge is visible in the same frame as the drawn silhouette.
	game.player.test_axis = 1
	for i in range(6): await step()
	game.player.test_axis = 0
	for i in range(20): await step()
	await capture("state-facing-right")

	# Facing left.
	game.player.test_axis = -1
	for i in range(6): await step()
	game.player.test_axis = 0
	for i in range(20): await step()
	await capture("state-facing-left")

	# Mid-air, near the peak of a fixed jump.
	game.player.test_axis = 0
	game.player.test_jump_pressed = true
	for i in range(20): await step()
	await capture("state-jumping")

	# Standing at the edge of the new narrow Zone 3 landing (x1020-1072),
	# to check the drawn silhouette against a platform edge it must read
	# clearly against.
	game.player.position = Vector2(1024, 298)
	game.player.velocity = Vector2.ZERO
	for i in range(10): await step()
	await capture("state-on-narrow-landing")

	game.queue_free()
	await process_frame
	quit()
