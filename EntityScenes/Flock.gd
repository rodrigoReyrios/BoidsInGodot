extends Node2D

#variable to store boids scene
var boid_template = preload("res://EntityScenes//Boid.tscn")

#variable for how many boids to spawn
export(int) var n_boids = 50

#variable for screen
var screen:Vector2

#######variables that controll the boid simulation###################################################

#the max speed and acceleration of the boid
export var maxspeed:float = 500
export var maxforce:float = 150

#weights for the seperation, alignment, and cohesion terms
export var wS:float = 1
export var wA:float = 1
export var wC:float = 1

#dtection radius variable
export var detect_rad:float = 150
######################################################################################################

export(int) var _seed = null

#variable for clock color
export(Color) var col = Color.black

#variable to keep totall number of boids
var boid_totall = 0

#variable to keep all boids in this flock
var all

#function to spawn in boids
func spawn_boids(N):
	#loop over the
	for i in range(N):
		#get random position on screen
		var xi = rand_range(0,screen.x)
		var yi = rand_range(0,screen.y)
		var ri = Vector2(xi,yi)
		#make instance of boid
		var boid = boid_template.instance()
		#place it on a random position
		boid.position = ri
		#set the paramaters for the boids while were here
		boid.maxforce = maxforce
		boid.maxspeed = maxspeed
		boid.detect_rad = detect_rad
		boid.wS = wS
		boid.wA = wA
		boid.wC = wC
		#add boid as child node
		add_child(boid)
		boid_totall += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#set seed
	if _seed == null:
		randomize()
	else:
		seed(_seed)
	#get screen variable
	screen = get_viewport_rect().size
	#spawn in boids
	spawn_boids(n_boids)
	#populate the flock
	all = getBoids()

#function to get the boids that are a child of this flock
func getBoids():
	var boids = []
	for c in get_children():
		if c.get_filename()=="res://EntityScenes/Boid.tscn":
			boids.append(c)
	return boids

#function to update boid paramaters
func boid_update():
	for boid in all:
		boid.maxspeed = maxspeed
		boid.maxforce = maxforce
		boid.wS = wS
		boid.wA = wA
		boid.wC = wC
		boid.detect_rad = detect_rad
		boid.col = col

func _process(delta):
	#make sure the boid paramaters are all set
	boid_update()
	#print(getBoids().size())

#function to add more boids every timeout
func _on_BoidAdding_timeout():
	var nn = 10
	print("Spawned ",nn," boids")
	spawn_boids(nn)
	print("Total Boids: ",boid_totall)
