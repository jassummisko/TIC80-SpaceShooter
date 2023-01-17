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
		@x = SCR.width

	update: =>
		super!
		@attackTime -= 1
		@moveTime -= 1
		@blink = max 0, @blink-1

		@move!

		if @health <= 0
			@die!

		if @attackTime <= 0
			@attack!
			@attackTime = rnd(120, 240)

	draw: =>
		if @blink > 0 
			pal(COLORS.DarkRed, COLORS.White)
		if @blink > 0 
			pal(COLORS.LightRed, COLORS.White)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(COLORS.DarkRed) 
		pal(COLORS.LightRed)

	move: =>
		@spawn!

		@targetY = max(2, min(plr.y, SCR.height-16))

		if @moveTime <= 0
			@y = math.floor(@y + ((@targetY - @y) * 0.2))
			if @y == @targetY
				@moveTime = rnd(40, 120)

	damage: (amt) =>
		sfx(SOUNDS.hit, 0, 120, 0)
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(Particles, Scrap(@x+4, @y+4, dir, 0, COLORS.White, life))
		@blink = 2
		@health -= amt

	die: =>
		super!
		sfx(SOUNDS.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add Particles, Scrap(@x+4, @y+4, dir, 0, COLORS.DarkRed, life)

		add Objs, RedAmmo plr, @x, @y for i=1, rnd(3, 9)

	attack: =>
		sfx SOUNDS.laser
		add Objs, Laser @x-2, @y+4, false, true