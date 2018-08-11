#!/usr/bin/ruby

# 参考: 平成26年理科年表から

# G: 6.67428 * (10**-11) m*m*m / (kg * s*s)

tmp = 6.67428 ** (1.0/3.0)
L = tmp*720
M = 0.05*(10**20)
T = 60*60*24
V = L/T

# 距離: L=tmp*720km
# 質量: M=0.05*10^20kg
# 時間: 1day
# G: 1.0 * L*L*L /(0.05*10^20kg * 1day*1day)

AU= 1.495978707 * (10**8)	# km

MASS_EARTH = 5.972 * (10**24)   # kg

class Planet
	attr_accessor :mass, :x, :y, :z, :vx, :vy, :vz
	def print()
		puts "#{@mass/M} #{@x/L} 0.0 0.0 0.0 #{@vy/V} 0.0"
	end
end

solar	= Planet.new
mercury	= Planet.new
venus	= Planet.new
earth	= Planet.new
mars	= Planet.new
jupiter	= Planet.new
saturn	= Planet.new
uranus	= Planet.new
neptune	= Planet.new

# 長半径
solar.x		= 0.0	* (10**8)
mercury.x	= 0.579	* (10**8)
venus.x		= 1.082	* (10**8)
earth.x		= 1.496	* (10**8)
mars.x		= 2.279	* (10**8)
jupiter.x	= 7.783	* (10**8)
saturn.x	= 14.294* (10**8)
uranus.x	= 28.750* (10**8)
neptune.x	= 45.044* (10**8)

# km/s
solar.vy	= 0.0
mercury.vy	= 47.36
venus.vy	= 35.02
earth.vy	= 29.78
mars.vy		= 24.08
jupiter.vy	= 13.06
saturn.vy	= 9.65
uranus.vy	= 6.81
neptune.vy	= 5.44

solar.mass	= 332946  * MASS_EARTH
mercury.mass= 0.05527 * MASS_EARTH
venus.mass	= 0.8150  * MASS_EARTH
earth.mass	= 1.0     * MASS_EARTH
mars.mass	= 0.1074  * MASS_EARTH
jupiter.mass= 317.83  * MASS_EARTH
saturn.mass	= 95.16   * MASS_EARTH
uranus.mass	= 14.54   * MASS_EARTH
neptune.mass= 17.15   * MASS_EARTH

puts "9"
puts "0.0"
solar.print
mercury.print
venus.print
earth.print
mars.print
jupiter.print
saturn.print
uranus.print
neptune.print
