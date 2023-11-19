#@tool
class_name Entity

extends Node2D

enum ENTITY_TYPE {ENTITY_ROCK, ENTITY_PAPER, ENTITY_SCISSORS}

@export var my_predators: Array[ENTITY_TYPE] = []
@export var my_prey: Array[ENTITY_TYPE] = []
@export var my_entity_type: ENTITY_TYPE
@export var my_sprite: Texture2D:
	set(x):
		$Sprite.texture = x
		my_sprite = x
	get:
		return my_sprite

var my_nearby_entities: Array[Entity] = []
@export var my_direction: Vector2 = Vector2.ZERO
@export var SPEED: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# loop through all entities in our area of influence
# if entity is a predator, try to move away from it
# if entity is a prey, try to move towards it
# needs a function to calculate which way to move based on which way
# it should go, there should be a bias towards chasing or running

# get all position vectors of all entities nearby towards the player 
# (so all the vectors from enemy or so, towards player)
# add them all together and then normalize
# move in that direction * speed`
func _process(_delta):
#	my_direction = Vector2.ZERO
	if not my_nearby_entities.is_empty():
		for e in my_nearby_entities:
			my_direction += e.position
		my_direction = my_direction.normalized()
		
#	else:
#		my_direction = 
	var next_position: Vector2 = position + my_direction.normalized() * SPEED
	if next_position.x < 0 or next_position.x > ProjectSettings.get_setting("display/window/size/viewport_width"):
		my_direction.x = -my_direction.x
	if next_position.y < 0 or next_position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
		my_direction.y = -my_direction.y
	
	print(next_position)
	position += my_direction.normalized() * SPEED
	print(position)

func _draw():
	pass


func _on_area_of_influence_area_entered(area: Area2D):
	var some_entity: Entity = area.get_parent()
	var entity_type: ENTITY_TYPE = some_entity.get_entity_type()
	if(entity_type in my_predators or entity_type in my_prey):
		#print("added new entity:", some_entity)
		my_nearby_entities.append(some_entity)


func _on_area_of_influence_area_exited(area):
	var some_entity: Entity = area.get_parent()
	if(some_entity in my_nearby_entities):
		#print("removed entity:", some_entity)
		my_nearby_entities.erase(some_entity)


func get_entity_type():
	return my_entity_type
