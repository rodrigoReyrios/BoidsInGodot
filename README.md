# Boids algorithm in Godot

This is the boids algorithm (taken from [this processing tutorial](https://processing.org/examples/flocking.html) which is in turn based on the work of Craig Reynolds) implemented in godot.

# Nodes
## Boid
the 'boid.tscn' scene defines the basic boid structure. Boids observe nearby boids to define a neighborhood (this is done by defining a detection radius). Boids then calculate their acceleration as a weighted sum of a separation, alignment, and cohesion terms.

- Separation: Boids steer away from boids in the neighborhood

- Alignment: Boids steer in such a way to align themselves with the velocity of their neighbors

- Cohesion: Boids steer toward the center of mass in their neighborhood

The weights of these 3 terms are variable. Boids also have their speed and and acceleration magnitudes clamped, these two are also variable. Clicking on any boid brings up the directions of the separation, alignment, and cohesion terms along with a visualization of their detection radius.

## Flock
The 'Flock.tscn' scene auto populates boids to run the simulation. Here all boids are children of the flock, and share the same paramaters (max speed, max force, detection radius, and weights). Flocks can also be colored.

# Demo Scenes

## MultiFlock
By default, boids only ever consider sibling nodes when trying to decide the neighborhood. That means that if a scene has two flock nodes it runs two independent flocking simulations. This demo scene shows a blue flock that likes to be aligned at a distance, and a red flock that likes to be close but has no alignment.