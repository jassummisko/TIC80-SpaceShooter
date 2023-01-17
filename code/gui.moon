export _DRAWGUI=->
	--PLR AND SCR ARE GLOBAL
	rectb(0, 0, SCR.width, SCR.height, 12)
	printShadow("Score: "..plr.score, 4, 4, 8, 12)
	printShadow("PRESS CTRL-R TO RESTART", 60, SCR.height/2-4, 8, 12) if not plr.alive

	barSize = 40

	--- RED BAR
	rect  80, 4, plr.ammo.Red/10, 6, COLORS.LightRed
	rectb 80, 4, barSize, 6, COLORS.DarkRed

	--- YELLOW BAR
	rect  130, 4, plr.ammo.Yellow/10, 6, COLORS.LightYellow
	rectb 130, 4, barSize, 6, COLORS.DarkYellow

	--- BLUE BAR
	rect  180, 4, plr.ammo.Blue/10, 6, COLORS.LightBlue
	rectb 180, 4, barSize, 6, COLORS.DarkBlue

