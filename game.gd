extends Node2D

# exports for editor
@export var fog: Sprite2D
@export var fogWidth = 1000
@export var fogHeight = 1000
@export var LightTexture: CompressedTexture2D
@export var lightWidth = 300
@export var lightHeight = 300
@export var Player: CharacterBody2D
@export var debounce_time = 0.01

# debounce counter helper
var time_since_last_fog_update = 0.0

var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

# here we cache things when Node2D is ready
func _ready():
  # get Image from CompressedTexture2D and resize it
	lightImage = LightTexture.get_image()
	lightImage.resize(lightWidth, lightHeight)

  # get center
	light_offset = Vector2(lightWidth/2, lightHeight/2)

  # create black canvas (fog)
	fogImage = Image.create(fogWidth, fogHeight, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color.BLACK)
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

  # get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())

  # update fog once or player will be under fog until you start move
	update_fog(Player.position)

# update our fog
func update_fog(pos):
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)

# main render loop. Here we don't need to call update every iteration.
# So we are using debounce here to execute code each "debounce_time"
# If debounce us ready, now we can check is character moving. And update fog if it's moving.
# Here I don't use single if block for debounce + player input because we don't need to check input
# if debounce is not ready. 
func _process(delta):
	time_since_last_fog_update += delta
	if (time_since_last_fog_update >= debounce_time):
		var player_input = Player.get_input()
		if player_input.length() > 0:
			time_since_last_fog_update = 0.0
			update_fog(Player.position)

### If you want to stick to mouse
### make sure you add optimizations here
#func _input(event):
#	update_fog(get_node("player").position)
