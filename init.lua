local function reg(name, collision_box)
    minetest.log("morecurves:"..name)
    local collisionbox = { type = "regular" }
    if(collision_box ~= nil) then
        collisionbox = {
            type = "fixed",
            fixed = collision_box
        }
    end
    minetest.log(dump(collisionbox))
    minetest.register_node("morecurves:"..name,
    {
        description = name,
        drawtype = "mesh",
        mesh = name..".obj",
        paramtype2 = "facedir",
        paramtype = "light",
        collision_box = collisionbox,
        selection_box = collisionbox,
        
        tiles = {{name="top.png",   backface_culling=true},
                 {name="bottom.png",backface_culling=true},
                 {name="right.png", backface_culling=true},
                 {name="left.png",  backface_culling=true},
                 {name="back.png",  backface_culling=true},
                 {name="front.png", backface_culling=true}},
        groups = { oddly_breakable_by_hand=3 },
    })
end

reg("_b_1")
reg("_b_2")
reg("_b_3")
reg("_b_4")
reg("a_1")
reg("a_1r")
reg("a_2")
reg("a_2r")
reg("a_3")
reg("a_3r")
reg("a_4")
reg("a1_1")
reg("a1_2")
reg("a1_3")
reg("a1_4")
reg("a2_1")
reg("a2_1r")
reg("a2_2")
reg("a2_2r")
reg("a2_3")
reg("a2_3r")
reg("a2_4")
reg("af_1")
reg("af_2")
reg("af_3")
reg("af_4")
reg("b_1")
reg("b_2")
reg("b_3")
reg("b_4", {{-0.412, -0.5, 0.175, 0.5, 0.5, 0.5}, {-0.167, -0.5, -0.167, 0.5, 0.5, 0.1745}, {0.175, -0.5, -0.412, 0.5, 0.5, -0.1675}})
reg("c_1")
reg("c_1r")
reg("c_2")
reg("c_2r")
reg("c_3")
reg("c_3r")
reg("c_4")
reg("c1_1")
reg("c1_1r")
reg("c1_2")
reg("c1_2r")
reg("c1_3")
reg("c1_3r")
reg("c1_4")
reg("d_1")
reg("d_2")
reg("d_3")
reg("d_4")