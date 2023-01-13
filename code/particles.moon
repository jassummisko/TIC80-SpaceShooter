--Particles
class Particle
	new: (x, y, dir, speed, col, life) =>
		@x = x
		@y = y
		@dir = dir
		@speed = speed
		@col = @col or col or 12
		@life = @life or life or 60
		@alive = true
	update: =>
		@x += (cos rad @dir) * @speed
		@y += (sin rad @dir) * @speed
		@life -= 1
		if @life < 0
			@alive = false

	draw: =>
		rect(@x, @y, 1, 1, @col)

class Star extends Particle
	col: 12
	life: 80

class Scrap extends Particle
	update: =>
		@speed = @life/10
		@x += math.cos(math.rad(@dir)) * @speed
		@y += math.sin(math.rad(@dir)) * @speed
		@life -= 1
		if @life < 0
			delObj(particles, self)