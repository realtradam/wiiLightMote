
require 'hue'
require 'cwiid'

bridge = Hue.application

colour = Hue::Colors::ColorTemperature.new(6500)
up = [colour,255]
right = [colour,255]
left = [colour,255]
down = [colour,255]

loop do
	begin
		puts "Searching for wiimote(press 1 + 2)"
		wiimote = WiiMote.new
		puts "Wiimote Connected"
		wiimote.rpt_mode = wiimote.rpt_mode = WiiMote::RPT_BTN | WiiMote::RPT_ACC
		
		wiimote.led = 9
		wiimote.get_state

		
			begin
				wiimote.get_state
				
				if ( wiimote.buttons & WiiMote::BTN_HOME ) != 0
					for bulb in bridge.bulbs
						if bulb.on?
							bulb.off
						else
							bulb.on
						end
					end
					sleep(0.245)
				end
				
				if ( wiimote.buttons & WiiMote::BTN_A ) != 0
					for bulb in bridge.bulbs
						if bulb.on?
							colour = Hue::Colors::ColorTemperature.new(((([[wiimote.acc[1].to_f,150.0].min,100.0].max - 100.0)/50.0) * 4500) + 2000)
							bulb.color = colour
						end
					end
					sleep(0.004)
				end
				
				if ( wiimote.buttons & WiiMote::BTN_B ) != 0
					for bulb in bridge.bulbs
						if bulb.on?
							colour = Hue::Colors::HueSaturation.new((([[wiimote.acc[1].to_f,150.0].min,100.0].max - 100.0)/50.0) * 65535, 255)
							bulb.color = colour
						end
					end
					sleep(0.004)
				end
				
				if ( wiimote.buttons & WiiMote::BTN_PLUS ) != 0
					for bulb in bridge.bulbs
						if bulb.on?
							if ( bulb.brightness + 15 ) < 255
								bulb.brightness += 15
							else
								bulb.brightness = 255
							end
						end
					end
				end
				
				if ( wiimote.buttons & WiiMote::BTN_MINUS ) != 0
					for bulb in bridge.bulbs
						if bulb.on?
							if ( bulb.brightness - 15 ) > 1 
								bulb.brightness -= 15
							else
								bulb.brightness = 1
							end
						end
					end
				end
				
				if ( wiimote.buttons & WiiMote::BTN_UP ) != 0
					for bulb in bridge.bulbs
						if (( wiimote.buttons & WiiMote::BTN_1 ) != 0) & bulb.on?
							#set preset
							up[0] = colour
							up[1] = bulb.brightness
							
						else
							if bulb.off?
								bulb.on
							end
							#load preset
							color = up[0]
							bulb.color = up[0]
							bulb.brightness = up[1]
						end
					end
				end				
				if ( wiimote.buttons & WiiMote::BTN_RIGHT ) != 0
					for bulb in bridge.bulbs
						if (( wiimote.buttons & WiiMote::BTN_1 ) != 0) & bulb.on?
							#set preset
							right[0] = colour
							right[1] = bulb.brightness
							
						else
							if bulb.off?
								bulb.on
							end
							#load preset
							color = right[0]
							bulb.color = right[0]
							bulb.brightness = right[1]
						end
					end
				end				
				if ( wiimote.buttons & WiiMote::BTN_DOWN ) != 0
					for bulb in bridge.bulbs
						if (( wiimote.buttons & WiiMote::BTN_1 ) != 0) & bulb.on?
							#set preset
							down[0] = colour
							down[1] = bulb.brightness
							
						else
							if bulb.off?
								bulb.on
							end
							#load preset
							color = down[0]
							bulb.color = down[0]
							bulb.brightness = down[1]
						end
					end
				end				
				if ( wiimote.buttons & WiiMote::BTN_LEFT ) != 0
					for bulb in bridge.bulbs
						if (( wiimote.buttons & WiiMote::BTN_1 ) != 0) & bulb.on?
							#set preset
							left[0] = colour
							left[1] = bulb.brightness
							
						else
							if bulb.off?
								bulb.on
							end
							#load preset
							color = left[0]
							bulb.color = left[0]
							bulb.brightness = left[1]
						end
					end
				end
				
			sleep(0.001)
			end until ( wiimote.buttons & WiiMote::BTN_2 ) != 0
		wiimote.close
		puts "Wiimote Disconnected"
	rescue RuntimeError => e
		puts e.message
		puts "Trying to connect again..."
	end
end

