--rift spotter
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"

Assets = {
	Asset("ATLAS","image/lunarbadge.xml"),
    Asset("IMAGE","image/lunarbadge.tex"),
	Asset("ATLAS","image/rain.xml"),
    Asset("IMAGE","image/rain.tex"),
}

AddClassPostConstruct("widgets/mapwidget", function(self)
	if (GLOBAL.TheWorld:HasTag("forest")) then
		self.riftspotterbutton = self:AddChild(ImageButton("image/lunarbadge.xml", "lunarbadge.tex"))
	
		self.riftspotterbutton:SetScale(0.8,0.8,0.8)
		self.riftspotterbutton:SetVAnchor(GLOBAL.ANCHOR_BOTTOM)
		self.riftspotterbutton:SetHAnchor(GLOBAL.ANCHOR_RIGHT)
		self.riftspotterbutton:SetPosition(-85,200,0) --1835

		self.riftspotterbutton:SetOnClick(function() self.riftspotterbutton:OnClickButton() end)

		function self.riftspotterbutton:OnClickButton()
			local w = GLOBAL.TheWorld.Map:GetSize()*4
			local h = GLOBAL.TheWorld.Map:GetSize()*4
			local riftFound = false
			local riftx
			local rifty
			for i = (GLOBAL.TheWorld.Map:GetSize())*-4, w, 4 do 
				for j = (GLOBAL.TheWorld.Map:GetSize())*-4, h, 4 do
					if (GLOBAL.TheWorld.Map:GetTileAtPoint(i, 0, j) == 266) then
						riftx = i
						rifty = j
						riftFound = true
					end
				end
			end

			if riftFound then
				local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
				if screen and screen.name == "MapScreen" then
					screen.minimap.minimap:ResetOffset()
					GLOBAL.ThePlayer.HUD.controls:FocusMapOnWorldPosition(screen, riftx, rifty)
				else
					GLOBAL.ThePlayer.HUD.controls:ShowMap(GLOBAL.Vector3(riftx, 0, rifty))
				end
				if self.rifttext then
					self.rifttext:SetString("")
				end
			else
				if self.rifttext == nil then
					self.rifttext = self:AddChild(Text(GLOBAL.TITLEFONT, 40, "No Rift Found!"))
					self.rifttext:SetPosition(0,90,0)
					print("Rift Not Found")
				end
			end
		end
	end
end)