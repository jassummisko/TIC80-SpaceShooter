class Enemy extends Entity
	type: types.Enemy
	score: 0

	collision: =>
		for obj in *objs
			if obj.type == types.Projectile
				if collide(obj, self)
					@damage(obj.damage)

	spawn: =>
		if @spawning
			@x = math.floor(@x + (@targetX - @x) * 0.1)
			@spawning = false if @x == @targetX

	die: =>
		@alive = false
		plr.score += @score	

	kill: => @health = 0