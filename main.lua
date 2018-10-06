--Bresenham's field of view demonstration
--by Spellweaver (spellsweaver@gmail.com)

fov = require ('FoV')

function wheremouse() --returns x,y of the cell mouse is pointed at
	local cellx = math.ceil(love.mouse.getX()/cell_width)
	cellx=math.max(cellx,0)
	local celly = math.ceil(love.mouse.getY()/cell_height)
	celly=math.max(celly,0)
	return {x=cellx,y=celly}
end

function love.load()
	cell_width,cell_height=20,20
	love.window.setMode (50*cell_width,50*cell_height,{fullscreen=false,vsync=true,resizable=false,borderless=false})
	love.window.setTitle ("Field of View demonstration")

	map={}
	for i=1,50 do
		map[i]={}
		for j=1,50 do
			map[i][j]=false
		end
	end

	vision={}
	for i=1,50 do
		vision[i]={}
	end

	viewdist=5
	circularview=true
	seeall=false
end

function love.draw()
		for i=1,50 do
			for j=1,50 do			
				if seeall or vision[i][j] then
					if map[i][j] then love.graphics.setColor(0,0,0)
					else love.graphics.setColor(255,255,255)
					end
				else
					love.graphics.setColor(60,60,60)
				end
				love.graphics.rectangle('fill',cell_width*(i-1),cell_height*(j-1),cell_width,cell_height)
			end
		end
end

function rescan()
	if not seeall and wheremouse().x>0 and wheremouse().x<=50 and wheremouse().y>0 and wheremouse().y<=50 then
	vision=FoVtable(map,wheremouse().x,wheremouse().y,viewdist,circularview)
	end
end

function love.mousepressed( x, y, button )
	if button=='l' then
		map[wheremouse().x][wheremouse().y] = not map[wheremouse().x][wheremouse().y]
		rescan()
	elseif button=='wu' then
		viewdist=math.min(viewdist+1,50)
		rescan()
	elseif button=='wd' then
		viewdist=math.max(viewdist-1,0)
		rescan()
	end

end

function love.update(dt)
	if wheremouse().x~=mousex0 or wheremouse().y~=mousey0 then
		mousex0,mousey0=wheremouse().x,wheremouse().y
		rescan()
	end
end

function love.keypressed(key)
	if key=='f' or key=='F' or key=='а' or key=='А' then
		circularview = not circularview
		rescan()
	elseif key=='c' or key=='C' or key=='с' or key=='С' then
		circularview=not circularview
	elseif key==' ' then
		seeall=not seeall
	elseif key=='+' or key=='kp+' or key=='=' then
		viewdist=math.min(viewdist+1,50)
		rescan()
	elseif key=='-' or key=='kp-' then
		viewdist=math.max(viewdist-1,0)
		rescan()
	end
end