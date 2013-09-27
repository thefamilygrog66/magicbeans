magicbeans_list = {
    { "Magic Jumping Beans", "jumping", 1, 5, 1},
    { "Magic Flying Beans", "flying", 2, 1, 0.02},
    { "Magic Running Beans", "running", 3, 1, 1},
}

for i in ipairs(magicbeans_list) do
	
    local beandesc = magicbeans_list[i][1]
    local bean = magicbeans_list[i][2]
    local beanspeed = magicbeans_list[i][3]
    local beanjump = magicbeans_list[i][4]
    local beangrav = magicbeans_list[i][5]
	
	--Item Registering
	minetest.register_craftitem("magicbeans:"..bean, {
		description = beandesc,
		inventory_image = "magicbeans_"..bean..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.above then
				minetest.env:add_item(pointed_thing.above, {name="magicbeans:"..bean})
				itemstack:take_item()
			end
			return itemstack
		end,
		on_use = function(itemstack, user, pointed_thing)		
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
		local j = math.random(3)
		local bean = magicbeans_list[j][2]
		minetest.env:add_item(pos, {name="magicbeans:"..bean})
	end,
})
	
