function love.load()
	-- library files
	class = require "assets.middleclass"
	require "wave2d"
	plyranm = wave2d:new("assets/test.wanm")
	love.graphics.setBackgroundColor(0,50,50)
	love.window.setMode(300,400)
	love.window.setTitle("wave2d demo")
end

function love.update(dt)
	plyranm:update(dt)
	love.window.setTitle("wave2d demo - FPS:"..love.timer.getFPS())
end

function love.draw()
	plyranm:draw(20,120)
	love.graphics.print("wave2d by notQuiteApex",20,20)
	love.graphics.print("current animation: "..plyranm:getAnimation(),20,50)
	love.graphics.print("press y,u,i,o,p for different animations",20,80)
end

function love.keypressed(k)
	if k=="escape" then love.event.quit(); return
	elseif k=="y" then plyranm:setAnimation("jim")
	elseif k=="u" then plyranm:setAnimation("notmain")
	elseif k=="i" then plyranm:setAnimation("double")
	elseif k=="o" then plyranm:setAnimation("You Spin Me Right Round")
	elseif k=="p" then plyranm:setAnimation("Bounce")
	end
end