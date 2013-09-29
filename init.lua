--Register beanstalk nodes
minetest.register_node("magicbeans:leaves", {
	tiles = {"magicbeans_leaves.png"},
	drawtype = "plantlike",
	walkable = false,
	climbable = true,
	paramtype = "light",
	groups = {dig_immediate = 3},
})

minetest.register_node("magicbeans:blank", {
	tiles = {"magicbeans_blank.png"},
	drawtype = "plantlike",
	walkable = false,
	climbable = true,
	paramtype = "light",
	groups = {dig_immediate = 3},
})

minetest.register_node("magicbeans:stem", {
	tiles = {"magicbeans_stem.png"},
	paramtype = "light",
	groups = {dig_immediate = 3},
})

minetest.register_node("magicbeans:cloud", {
	tiles = {"default_cloud.png"},
	walkable = false,
	climbable = true,
	paramtype = "light",
	sunlight_propagates = true,
	groups = {dig_immediate = 3},
})

magicbeans_list = {
    { "Magic Jumping Beans", "jumping", 1, 5, 1},
    { "Magic Flying Beans", "flying", 2, 1, 0.02},
    { "Magic Running Beans", "running", 3, 1, 1},
    { "Magic Beanstalk Beans", "beanstalk", 1, 1, 1},
}

for i in ipairs(magicbeans_list) do
	
    local beandesc = magicbeans_list[i][1]
    local bean = magicbeans_list[i][2]
    local beanspeed = magicbeans_list[i][3]
    local beanjump = magicbeans_list[i][4]
    local beangrav = magicbeans_list[i][5]
	
	--Register beans
	minetest.register_craftitem("magicbeans:"..bean, {
		description = beandesc,
		inventory_image = "magicbeans_"..bean..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.above then
				if bean ~= "beanstalk" then
					minetest.env:add_item(pointed_thing.above, {name="magicbeans:"..bean})
				else
					-- Grow Beanstalk
					minetest.chat_send_player(placer:get_player_name(),"It's gonna grow - wait for it!")
					math.randomseed(os.time())
					local stalk = pointed_thing.above
					stalk.x = stalk.x - 2
					stalk.z = stalk.z - 2
					local height = 127 - stalk.y
					local c = {1, 1, 1, 1, 2, 1, 1, 1, 1}
					local d = {1, 2, 3, 6}
					local e = {9, 8, 7, 4}
					local ex = 0
					local zed = 1
					local blank = 0
					for why = 0,height do
						blank = blank + 1
						if blank > 4 then blank = 1 end
						why1 = stalk.y + why
						for i = 1,9 do
							ex = ex + 1
							if ex > 3 then
								zed = zed + 1
								ex = 1
							end
							if c[i] == 1 then
								node = "magicbeans:leaves"
								if i == d[blank] or i == e[blank] then node = "magicbeans:blank" end
							else
								node = "magicbeans:stem"
							end
							ex1 = stalk.x + ex
							zed1 = stalk.z + zed
							minetest.set_node({x=ex1, y=why1, z=zed1},{name=node})
						end
						zed = 0
					end
					-- Build cloud platform
					for ex = -10,20 do
						for zed = -10,20 do
							ex1 = stalk.x + ex
							zed1 = stalk.z + zed
							minetest.set_node({x=ex1, y=why1, z=zed1},{name="magicbeans:cloud"})
						end	
					end				
				end
				itemstack:take_item()
			end
			return itemstack
		end,
		on_use = function(itemstack, user, pointed_thing)
			if bean == "beanstalk" then
				minetest.chat_send_player(user:get_player_name(),"You can't eat magic beanstalk beans - you have to plant them.")	
				return
			end
			user:set_physics_override(beanspeed, beanjump, beangrav)
			minetest.chat_send_player(user:get_player_name(),"Whoa, that was a strong magic "..bean.." bean!")	
			local normjump = function()
				user:set_physics_override(1, 1, 1)
				minetest.chat_send_player(user:get_player_name(),"Looks like you're back to normal now - no more crazy "..bean.."!")							
			end	
			minetest.after(30, normjump)
			itemstack:take_item()
			return itemstack
		end, 
	})	
	
end

-- Bean Spawning
minetest.register_abm(
	{nodenames = {"default:dirt_with_grass"},
	interval = 600,
	chance = 3000,
	action = function(pos)
		pos.y = pos.y + 1
	    math.randomseed(os.time())
		local j = math.random(4)
		local bean = magicbeans_list[j][2]
		minetest.env:add_item(pos, {name="magicbeans:"..bean})
	end,
})
