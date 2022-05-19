extends KinematicBody2D

#variables to store velocity and acceleration
var _velocity:Vector2
var _acceleration:Vector2

#the max speed and acceleration of the boid
export var maxspeed:float = 500
export var maxforce:float = 150

#variable to store the viewport
var screen:Vector2

#variable for allowing debugging statements and timing
var debug:bool = false

#variables to store SAC acceleration terms
var S:Vector2
var A:Vector2
var C:Vector2

#weights for the seperation, alignment, and cohesion terms
export var wS:float = 1
export var wA:float = 1
export var wC:float = 1

#dtection radius variable
export var detect_rad:float = 150

#variable to store number of neighbors
var neighbors:int

#variable to store boid color
var col = Color.black

#variable to store all boids that can interact with this boid
var all

#function to produce a steering accleration directed towards a target
func Steer(target):
	#calculate the vector from the velocity to the target scaled to max speed
	var steer = (target.normalized()*maxspeed) - _velocity
	#clamp this vector to max force
	return steer.clamped(maxforce)

#checks periodic boundary conditions and loops boids 
func periodicBoundary():
	position.x = wrapf(position.x,0,screen.x)
	position.y = wrapf(position.y,0,screen.y)

func _on_DebugButton_pressed():
	#negate debug
	debug = not debug
	print("Debug set to: ", debug)

#function that controlls debug statements
func debug():
	print("S: ",S)
	print("A: ",A)
	print("C: ",C)
	print("Neighs: ",neighbors,"\n")

#function that debugs on timer timeout
func _on_DebugTimer_timeout():
	if debug:
		debug()

#function to get relevant boids
func getBoids():
	var boids = []
	var par = get_parent()
	#get children of this parent
	for child in par.get_children():
		if child.get_filename() == "res://EntityScenes/Boid.tscn":
			boids.append(child)
	return boids

#function for updating all SAC components together to save some looping
func SAC():
	#start by making SAC temp variables
	var S_temp:Vector2 = Vector2.ZERO
	var A_temp:Vector2 = Vector2.ZERO
	var C_temp:Vector2 = Vector2.ZERO

	#count the neighbors
	var n:int = 0
	
	#loop over all boids
	for other in all:
		#get seperation vector 
		var rij:Vector2 = position - other.position
		#skip if this boid if its self
		var dmag = rij.length()
		if 0<dmag:
			#skip this boid if its out of detection range
			if dmag < detect_rad:
				#seperation needs the vector from other to this boid
				#divided by the square length
				#S_temp += rij/rij.length_squared()
				S_temp += rij/pow(dmag,2)
				#alignment needs the velocity of the other boid since its average velocity
				A_temp += other._velocity
				#cohesion term need the position since its average center
				C_temp += other.position
				
				n+=1
	#let the boid know how many neighbors it has
	neighbors = n
	#average out by number of neighbors
	if n!=0:
		S_temp /= n
		A_temp /= n
		C_temp /= n
		#cohesion is technicly vector from this boids position to center
		C_temp -= position
	#get the steer vector for every SAC variable if its non zero
	#else just use zero
	#this last steer vector is the new SAC component
	if S_temp.length() != 0:
		S = Steer(S_temp)
	else:
		S = Vector2.ZERO
	if A_temp.length() != 0:
		A = Steer(A_temp)
	else:
		A = Vector2.ZERO
	if C_temp.length() != 0:
		C = Steer(C_temp)
	else:
		C = Vector2.ZERO

#function to send variables to visual drawing
func send_visual_data():
	#get the child node that controlls drawing
	var vis = $BoidVisual
	#send the velocity and acceleration
	vis._velocity = _velocity
	vis._acceleration = _acceleration
	#send the detection radius
	vis.detect_rad = detect_rad
	#send the current SAC components and their wieghts
	vis.S = S
	vis.A = A
	vis.C = C
	vis.wS = wS
	vis.wA = wA
	vis.wC = wC
	#send over the coloe
	vis.col = col

func _ready():
	#get the screen dimensions
	screen = get_viewport_rect().size
	#initalize SAC terms
	S = Vector2.ZERO
	A = Vector2.ZERO
	C = Vector2.ZERO
	#boid should have a random velcoity set
	var rng = rand_range(0,2*PI)
	_velocity = maxspeed/2*Vector2(cos(rng),sin(rng))
	#boid should not have any acceleration at start
	_acceleration = Vector2.ZERO
	#set all the boids
	all = getBoids()


func _physics_process(delta):
	#update SAC terms, also updates neighbors
	SAC()
	#update the acceleration term, each of there terms are already clamped to maxforce
	_acceleration = (wS*S)+(wA*A)+(wC*C)
	#update the velocity with the acceleration for time delta
	_velocity += delta*_acceleration
	#make sure to clamp velocity to maxspeed
	_velocity = _velocity.clamped(maxspeed)
	#move and slide the bject acording to updated velocity
	_velocity = move_and_slide(_velocity)
	#apply perioidc boundary conditions
	periodicBoundary()
	#send the visual data to drawig node
	send_visual_data()
