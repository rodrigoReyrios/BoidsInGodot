extends Node2D

#list to store circle data (x,y,r)
var CircList = []

#variable for max size
var maxrad = 50

#variable for the radius multiplyer to try every step
var rmult = 0.99

#variable for desired tries per circle
var tries = 3

#variable for position of the circle packing to try and fill
var loc
#variable for size of filling
var fill = Vector2(1200,1200)

#function to try and generate a circle in the center box
func gencirc():
	#pick out a random point in the box
	var xi = rand_range(loc.x,loc.x+fill.x)
	var yi = rand_range(loc.y,loc.y+fill.y)
	
	#star the radius at max radius
	var curr_r = maxrad
	
	#here Ill stop and add the circle if theres no circle right now
	if CircList.size()==0:
		CircList.append(Vector3(xi,yi,curr_r))
		return null
	#the rest of the code happens as soon as there is atleast 1 circle
	
	#variable to check if circle has been placed
	var beenplaced = true
	
	#before anything if weve placed a point in a current circle its never going to work so we check this first
	var goodp = false
	while not goodp:
		#assume we have a good point
		var goodpoint = true
		#loop over all the circles
		for other in CircList:
			#get the distance from this point to the other circle
			var d = pow(pow((xi-other.x),2)+pow((yi-other.y),2),0.5)
			#get the radius of the circle and add a little buffer
			var r = other.z*1.1
			#if d<r then the point is in the circle
			if d<r:
				goodpoint = false
				break
		#if weve detected a bad point reset xi, yi
		if not goodpoint:
			xi = rand_range(loc.x,loc.x+fill.x)
			yi = rand_range(loc.y,loc.y+fill.y)
		else:
			#else the point is good and we can break the loop
			goodp = true
	
	#loop over the number of attempts allowed per circle
	while beenplaced:
		#boolean to see if the circle can be placed
		var canplace = true
		#loop over the current circles list
		for other in CircList:
			# to see if these circles are overlapping get the distance between centers
			var d = pow(pow((xi-other.x),2)+pow((yi-other.y),2),0.5)
			#if this circle overlaps with the other one then d < r1+r2
			if d<(curr_r+other.z):
				canplace = false
		#now either the circle has been placed or not
		if canplace:
			#actualy add the circle and let the loop know its been placed
			CircList.append(Vector3(xi,yi,curr_r))
			beenplaced = false
		#the next time this loops the circle couldnt be placed
		#shrink the radius a bit
		curr_r *= 0.7

#function to try and generate n circles
func gencircs(n):
	for i in range(n):
		gencirc()

#function to draw circles
func draw_circs():
	for circ in CircList:
		#get the positions and radius
		var x = circ.x
		var y = circ.y
		var r = circ.z
		draw_circle(Vector2(x,y),r,Color.red)

func _ready():
	#set seed
	seed(20)
	#get the screen
	var screen = get_viewport_rect().size
	var locx = (screen.x/2) - (fill.x/2)
	var locy = (screen.y/2) - (fill.y/2)
	loc = Vector2(locx,locy)
	#generate circles
	#gencircs(2000)

func _draw():
	#draw a box to visualize packing area
	#draw_cent_square()
	#try and draw circles
	#draw_circs()
	pass

func _process(delta):
	update()

#function to draw rec at center
func draw_cent_square():
	draw_rect(Rect2(loc,fill),Color.red,false)
