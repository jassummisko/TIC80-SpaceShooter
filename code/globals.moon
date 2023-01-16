debug = false
t = 0
scr = {
	width: 240
	height: 136
}

objs = {}
particles = {}

do --enums
	export colors = {
		TransBlack: 0
		DarkPurple: 1
		LightPurple: 7
		DarkRed: 2
		LightRed: 3
		DarkYellow: 4
		LightYellow: 14
		DarkGreen: 6
		LightGreen: 5
		DarkBlue: 8
		LightBlue: 9
		DarkCyan: 10
		LightCyan: 11
		White: 12
		Gray: 13
	}

	export sounds = {
		genericAttack: 0
		boom: 1
		hit: 2
		laser: 3
		pickUp: 4
		bolt: 5
		spark: 6
	}

	export types = {
		Player: 1
		Enemy: 2
		Projectile: 3
		EnemyProjectile: 4
		Item: 5
	}
	types.None = 0

	export weapons = {
		Bullet: 0
		Bolt: 1
		Bomb: 2
	}