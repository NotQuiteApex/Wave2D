function string:split(sep)
	local res,from,sepf,sept = {},1,self:find(sep,1)
	while sepf do
		table.insert(res,self:sub(from,sepf-1))
		from = sept+1
		sepf,sept = self:find(sep,from)
	end
	table.insert(res,self:sub(from))
	return res
end

wave2d = class("wave2d")

function wave2d:initialize(s)
	self.playing = true
	self.ca = "main"
	self.cf = 1
	self.dt = 0
	self.framem = {d=0,i="",x=0,y=0,r=0,sx=1,sy=1,ox=0,oy=0,kx=0,ky=0}
	local t=tonumber
	
	s = love.filesystem.read(s):split("\r\n")
	-- Image declartation
	self.img = love.graphics.newImage(s[1])
	local imw,imh = self.img:getWidth(),self.img:getHeight()
	
	-- Quads declaration
	s[2] = s[2]:split(";")
	self.quad = {}
	for i=1,#s[2] do
		local r = s[2][i]:split(",")
		self.quad[r[1]] = love.graphics.newQuad(t(r[2]),t(r[3]),t(r[4]),t(r[5]), imw,imh)
	end
	
	-- frames declaration
	self.f = {}
	for i=3,#s do
		local a = s[i]:split(":")
		if i==3 then self.ca = a[1] end -- set first animation in list as default
		self.f[a[1]] = {}
		local b = a[2]:split(";")
		for j=1,#b do
			local r = b[j]:split(",")
			self.f[a[1]][j] = {}
			for q=1,#r do local n=r[q]:split("=");if n[1]~="i" then self.f[a[1]][j][n[1]]=t(n[2]) else self.f[a[1]][j][n[1]]=n[2] end end
		end
	end
end

function wave2d:update(dt)
	if self.playing then 
		self.dt = self.dt + dt
		if self.dt >= self.framem.d then
			self.dt = self.dt - self.framem.d
			self.cf = self.cf+1
		end
		if self.cf > #self.f[self.ca] then self.cf = self.cf - #self.f[self.ca] end
		for i,v in pairs(self.f[self.ca][self.cf]) do self.framem[i] = v end
	end
end

function wave2d:reset()
	self.dt,self.cf,self.framem = 0,1,{d=0,i="",x=0,y=0,r=0,sx=1,sy=1,ox=0,oy=0,kx=0,ky=0}
	for i,v in pairs(self.f[self.ca][self.cf]) do self.framem[i] = v end
end
function wave2d:toggle(b) self.playing = b or not self.playing end
function wave2d:setAnimation(s,b) self.ca=s; if not b then self:reset() end end
function wave2d:setDT(a) self.dt=a end
function wave2d:setFrame(a) self.cf=a end

function wave2d:getDT(a) return self.dt end
function wave2d:getFrame(a) return self.cf end
function wave2d:getAnimation() return self.ca end

function wave2d:draw(x,y,r,sx,sy,ox,oy,kx,ky)
	x=x or 0; y=y or 0; r=r or 0; sx=sx or 1; sy=sy or 1; ox=ox or 0; oy=oy or 0; kx=kx or 0; ky=ky or 0
	local f = self.framem
	love.graphics.draw(self.img, self.quad[f.i], f.x+x,f.y+y, f.r+r, f.sx*sx,f.sy*sy, f.ox+ox,f.oy+oy, f.kx+kx,f.ky+ky)
end