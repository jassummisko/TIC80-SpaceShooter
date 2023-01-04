class TrackerPew extends Enemy
	w: 1
	h: 2
	spr: 259
	score: 10

	new: (...) =>
		super ...
		@blink = 0
		@spawning = true

		@health = 12
		@moveTime = rnd(40, 120)
		@attackTime = rnd(120, 240)
		@targetY = plr.y
		@targetX = @x
		@x = scr.width

	update: =>
		super!
		@attackTime -= 1
		@moveTime -= 1
		@blink = max 0, @blink-1

		@move!
		@collision!

		if @health <= 0
			@die!

		if @attackTime <= 0
			@attack!
			@attackTime = rnd(120, 240)

	draw: =>
		if @blink > 0 
			pal(colors.DarkRed, colors.White)
		if @blink > 0 
			pal(colors.LightRed, colors.White)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(colors.DarkRed) 
		pal(colors.LightRed)

	move: =>
		@spawn!

		@targetY = max(2, min(plr.y, scr.height-16))

		if @moveTime <= 0
			@y = math.floor(@y + ((@targetY - @y) * 0.2))
			if @y == @targetY
				@moveTime = rnd(40, 120)

	damage: (amt) =>
		sfx(sounds.hit, 0, 120, 0)
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.White, life))
		@blink = 2
		@health -= amt

	die: =>
		super!
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add particles, Scrap(@x+4, @y+4, dir, 0, colors.DarkRed, life)

	attack: =>
		sfx sounds.laser
		add objs, Laser(@x-2, @y+4, false, true)