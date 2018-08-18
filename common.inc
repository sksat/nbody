global_settings { assumed_gamma 1.0 }

#macro LIGHT_SRC(p, at)
light_source{
	p
	color rgb <1,1,1>
	parallel
	point_at at
}
#end

#macro CAM(p, l, a)
	camera{
		location p
		angle a
		look_at l
	}
#end

#macro SP(p, r, col)
	sphere{
		p, r
		pigment {
			rgb col
		}
	}
#end
