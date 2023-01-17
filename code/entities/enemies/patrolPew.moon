class PatrolPew extends Enemy
	w: 1
	h: 2
	spr: 259
    score: 10

	new: (...) =>
		super ...
		@health = 12
		@blink = 0
		@attackTime = rnd(60, 120)
		@targetX = @x
		@x = SCR.width
		@spawning = true
		@col1 = COLORS.DarkBlue
		@col2 = COLORS.LightBlue
		@speed = 1
		@dir = 1

	update: =>
		super!

		@attackTime -= 1
		@blink = max(0, @blink-1)

		@move!

		if @health <= 0
			@die!

		if @attackTime <= 0
			@attack!
			@attackTime = rnd(100, 200)

	draw: =>
		if @blink > 0 then pal(COLORS.DarkRed, COLORS.White) else pal(COLORS.DarkRed, @col1)
		if @blink > 0 then pal(COLORS.LightRed, COLORS.White) else pal(COLORS.LightRed, @col2)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(COLORS.DarkRed, COLORS.DarkRed)
		pal(COLORS.LightRed, COLORS.LightRed)

	move: =>
		@spawn!
		@y += @speed * @dir
		if @y <= 2 				then @dir =  1
		if @y >= SCR.height-18	then @dir = -1

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
			add(Particles, Scrap(@x+4, @y+4, dir, 0, COLORS.DarkBlue, life))

		add Objs, BlueAmmo plr, @x, @y for i=1, rnd(3, 9)

	attack: =>
		sfx(SOUNDS.laser)
		add(Objs, Laser(@x-2, @y+4, false, true))