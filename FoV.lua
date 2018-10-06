-----------------------------------------
-- field of vision computation for 2d array
-- based on Bresenham's line algorithm
-- coded by Spellweaver (spellsweaver@gmail.com)
------------------------------------------
function FoV(visblock,xmax,ymax,x,y,limit,circle)
	-- a version that allows one to use any function that indicates visibility
	-- visblock should return true where the vision is blocked and take x,y as arguments
	-- Limit is radius of field of vision. Default inf. Limit of 0 means the only cell seen is the one of x,y.
	-- Circle=true means field of vision is circle, otherwise square. Default false.
	x=x or 1
	y=y or 1
	limit=limit or inf
	xmax = xmax or 50
	ymax = ymax or 50

	local function onborder(x2,y2)
		-- returns true if cell is right on the border of vision
		-- includes both circular and square FoV
		return circle and (x2-x)*(x2-x)+(y2-y)*(y2-y)<limit*limit and (x2==1 or x2==xmax or y2==1 or y2==ymax) 
		or circle and (x2-x)*(x2-x)+(y2-y)*(y2-y)<limit*limit and (x2-x)*(x2-x)+(y2-y)*(y2-y)>=(limit-2)*(limit-2)
		or not circle and ((math.abs(y2-y)<=limit and (math.abs(x2-x)==limit or math.abs(x2-x)<=limit and (x2==1 or x2==xmax))) or
		(math.abs(x2-x)<=limit and (math.abs(y2-y)==limit or math.abs(y2-y)<=limit and (y2==1 or y2==ymax))) )
	end

	local fov={}
	for i=1,xmax do
		fov[i]={}
	end

	local function bresenham(x2,y2)
		-- follows the line from (x,y) to (x2,y2) until the first obstacle, marking cells as visible
		local xi,yi = x,y
		local dx,dy = (x2-x),(y2-y)
		local eps = 0 -- error
		ix = dx > 0 and 1 or -1
		iy = dy > 0 and 1 or -1
		dx,dy=math.abs(dx),math.abs(dy)
		if dx>=dy then
			local deltaeps=dy
			for xi=x,x2,ix do
				if fov[xi] then fov[xi][yi]=true end
				if visblock(xi,yi) then break end
				eps=eps+deltaeps
				if 2*eps>=dx and (2*eps~=dx or ix>0) then
					yi=yi+iy
					eps=eps-dx
				end
			end
		else
			local deltaeps=dx
			for yi=y,y2,iy do

				if fov[xi] then fov[xi][yi]=true end

				if visblock(xi,yi) then break end
				eps=eps+deltaeps
				if 2*eps>=dy and (2*eps~=dy or iy>0) then
					xi=xi+ix
					eps=eps-dy
				end
			end
		end

	end


	for i=1,xmax do
		for j=1,ymax do
			if onborder(i,j) then
				bresenham(i,j)
			end
		end
	end

	return fov
end

function FoVtable(field,x,y,limit,circle)
--
--[[
	a version that allows the use of pre-created table of visibility
	field is a 2d array of true and false where true means that vision is blocked
	field format is 
		{
		{field[1,1], field[1,2], field[1,3]},
		{field[2,1], field[2,1], field[2,3]},
		{field[3,1], field[3,1], field[3,3]}
		}
	Size is detected automatically.

]]--
	function vis(x,y)
		return field[x][y]
	end
	return FoV(vis,#field,#field[1],x,y,limit,circle)

end