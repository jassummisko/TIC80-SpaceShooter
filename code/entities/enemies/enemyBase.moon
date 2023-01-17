class Enemy extends Entity
	score: 0

	damage: (amt) =>
		sfx(SOUNDS.hit, 0, 120, 0)
		@blink = 2
		@health -= amt

	spawn: =>
		if @spawning
			@x = math.floor(@x + (@targetX - @x) * 0.1)
			@spawning = false if @x == @targetX

	die: =>
		@alive = false
		plr.score += @score	

	kill: => @health = 0