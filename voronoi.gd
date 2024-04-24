extends Node2D

enum SpaceMetric {
	M_025,
	M_05,
	M_075,
	M_08,
	M_09,
	M_095,
	M_099,
	MANHATTAN,
	M_11,
	M_12,
	M_13,
	M_15,
	M_17,
	EUCLID,
	M_3,
	M_4,
	M_5,
	CHEBYSHEV,
}

const SIZE := 640
@export var SITES_COUNT := 10:
	set(new_value):
		SITES_COUNT = new_value
		restructure_points()
		restructure_colors()
		want_redraw = true
		queue_redraw()

@export var METRIC := SpaceMetric.EUCLID:
	set(new_value):
		METRIC = new_value
		want_redraw = true
		queue_redraw()

@export var POINTS_SEED := 8:
	set(new_value):
		POINTS_SEED = new_value
		restructure_points()
		want_redraw = true
		queue_redraw()

@export var COLOR_SEED := 84:
	set(new_value):
		COLOR_SEED = new_value
		restructure_colors()
		want_redraw = true
		queue_redraw()
		
@export_range(-1.0, 1.0) var UNSATURATION = 0.0:
	set(new_value):
		UNSATURATION = new_value
		restructure_colors()
		want_redraw = true
		queue_redraw()

@export_range(1, 500) var DETALIZATION := 1:
	set(new_value):
		DETALIZATION = new_value
		want_redraw = true
		queue_redraw()

var sites : Array[Vector2] = []
var sites_colors : Array[Color] = [
	#Color8(224, 240, 234),
	#Color8(149, 173, 190),
	#Color8(87, 79, 125),
	#Color8(80, 58, 101),
	#Color8(60, 42, 77),
	
	#Color8(73, 43, 124),
	#Color8(48, 21, 81),
	#Color8(237, 138, 10),
	#Color8(246, 217, 18),
	#Color8(255, 242, 156),
	
	#Color8(249, 180, 171),
	#Color8(253, 235, 211),
	#Color8(38, 78, 112),
	#Color8(103, 145, 134),
	#Color8(187, 212, 206),
	
	#Color8(7, 36, 72),
	#Color8(78, 212, 210),
	#Color8(255, 203, 0),
	#Color8(248, 170, 75),
	#Color8(255, 97, 80),
]

var want_redraw := false

func restructure_points():
	sites.clear()
	
	seed(POINTS_SEED)
	for i in range(SITES_COUNT):
		var x := randi_range(0, SIZE-1)
		var y := randi_range(0, SIZE-1)
		var p := Vector2(x, y)
		
		sites.append(p)

func restructure_colors():
	sites_colors.clear()
	
	seed(COLOR_SEED)
	for i in range(SITES_COUNT):
		var c := Color(randf(), randf(), randf())
		c = Color.from_hsv(c.h, clamp(c.s - UNSATURATION, 0.0, 1.0), c.v)
		
		sites_colors.append(c)

func minkovski_distance(a : Vector2, b : Vector2, order: float) -> float:
	return pow(pow(abs(b.x - a.x), order) + pow(abs(b.y - a.y), order), 1 / order)

func distance(a : Vector2, b : Vector2, metric = SpaceMetric.EUCLID) -> float:
	match metric:
		SpaceMetric.EUCLID:
			return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
		SpaceMetric.MANHATTAN:
			return abs(b.x - a.x) + abs(b.y - a.y)
		SpaceMetric.CHEBYSHEV:
			return max(abs(b.x - a.x), abs(b.y - a.y))
		SpaceMetric.M_025:
			return minkovski_distance(a, b, 0.25)
		SpaceMetric.M_05:
			return minkovski_distance(a, b, 0.5)
		SpaceMetric.M_075:
			return minkovski_distance(a, b, 0.75)
		SpaceMetric.M_08:
			return minkovski_distance(a, b, 0.8)
		SpaceMetric.M_09:
			return minkovski_distance(a, b, 0.9)
		SpaceMetric.M_095:
			return minkovski_distance(a, b, 0.95)
		SpaceMetric.M_099:
			return minkovski_distance(a, b, 0.99)
		SpaceMetric.M_11:
			return minkovski_distance(a, b, 1.1)
		SpaceMetric.M_12:
			return minkovski_distance(a, b, 1.2)
		SpaceMetric.M_13:
			return minkovski_distance(a, b, 1.3)
		SpaceMetric.M_15:
			return minkovski_distance(a, b, 1.5)
		SpaceMetric.M_17:
			return minkovski_distance(a, b, 1.7)
		SpaceMetric.M_3:
			return minkovski_distance(a, b, 3)
		SpaceMetric.M_4:
			return minkovski_distance(a, b, 4)
		SpaceMetric.M_5:
			return minkovski_distance(a, b, 5)
	return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))

func _ready():
	restructure_points()
	restructure_colors()

func _draw():
	if not want_redraw:
		return
	
	if want_redraw:
		want_redraw = false
	
	var start := Time.get_ticks_msec()
	
	for y in range(0, SIZE, DETALIZATION):
		for x in range(0, SIZE, DETALIZATION):
			var p := Vector2(x, y)
			var min_dist := 9999999.0
			var belonged_site := -1
			
			for site_idx in sites.size():
				var site := sites[site_idx]
				var dist := distance(site, p, METRIC)
				if dist < min_dist:
					min_dist = dist
					belonged_site = site_idx
			
			var c := sites_colors[belonged_site]
			
			if DETALIZATION == 1:
				draw_line(p, p + Vector2(1, 1), c, 1.0, true)
			else:
				var points := PackedVector2Array([
					Vector2(x, y),
					Vector2(x + DETALIZATION, y),
					Vector2(x + DETALIZATION, y + DETALIZATION),
					Vector2(x, y + DETALIZATION),
				])
				draw_colored_polygon(points, c)
			
	for site_idx in sites.size():
		var site := sites[site_idx]
		draw_circle(site, 5, Color.BLACK)
	
	var stop := Time.get_ticks_msec()
	print((stop - start)/1000.0)
