extends Node2D

#variables that store the velocity and acceleration
#position is already tracked through being a child node
var _velocity:Vector2
var _acceleration:Vector2

#variables for the boids seperation, alginment, and cohesion acceleration and their weight
var S:Vector2
var A:Vector2
var C:Vector2
var wS:float
var wA:float
var wC:float

#variable to store detection radius
var detect_rad:float

#boolean to controll if seondary drawings should be drawn
var extra_visuals:bool = false

#variable storing boids color
var col

#funtion to draw visuals that are probably important to see all the time
func draw_primary():
	#draw a dot at the position
	draw_circle(position,10,col)

func draw_secondary():
	#draw detection radius
	var c = Color.blueviolet
	c.a = 0.1
	draw_circle(position,detect_rad,c)
	#calculate the SAC components direction
	var Sfin = (S*wS).normalized()
	var Afin = (A*wA).normalized()
	var Cfin = (C*wC).normalized()
	
	draw_line(position,position+(Sfin*detect_rad),Color.red)
	draw_line(position,position+(Afin*detect_rad),Color.green)
	draw_line(position,position+(Cfin*detect_rad),Color.blue)

func _ready():
	#set inital v and a vectors to zero
	_velocity = Vector2.ZERO
	_acceleration = Vector2.ZERO
	#set the inital SAC to zero vectors
	S = Vector2.ZERO
	A = Vector2.ZERO
	C = Vector2.ZERO
	#set detection radius to zero
	detect_rad = 0

func _draw():
	#draw primary parts
	draw_primary()
	if extra_visuals:
		draw_secondary()

func _process(delta):
	update()

func _on_DebugButton_pressed():
	#when debugg buttin is pressed enable eextra visuals
	extra_visuals = not extra_visuals
