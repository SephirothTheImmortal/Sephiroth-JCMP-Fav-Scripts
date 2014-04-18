class "ApparelExample"

function ApparelExample:__init()
	self.enabled = false

	Events:Subscribe("RegisteredApparel", self, self.RegisteredApparel)
	Events:Subscribe("PlayerApparel", self, self.PlayerApparel)
	Events:Subscribe("ModuleLoad", self, self.ModuleLoad)
	Events:Subscribe("ModulesLoad", self, self.ModuleLoad)
	Events:Subscribe("KeyUp", self, self.KeyUp)
	Events:Subscribe("Render", self, self.Render)
end

function ApparelExample:RegisteredApparel(args)
	if self.enabled then return end

	self.enabled = true
	self.registeredApparel = args.registered
	self.playerApparel = {}
end

function ApparelExample:PlayerApparel(args)
	self.playerApparel = args.apparel

	if self.editing then
		self.apparelIndex = self.playerApparel[self.slot] or 0
	end
end

function ApparelExample:ModuleLoad()
	Events:Fire("FetchRegisteredApparel")
	Events:Fire("FetchPlayerApparel")
end

function ApparelExample:KeyUp(args)
	if not self.enabled then return end

	if args.key == string.byte("M") then
		self.editing = not self.editing
		self.slot = 1
		self.apparelIndex = self.playerApparel[self.slot] or 0
	elseif self.editing then
		if args.key == VirtualKey.Right then
			local found = false
			local oldIndex = self.apparelIndex
			self.apparelIndex = nil

			for k, v in pairs(self.registeredApparel) do
				if found then
					self.apparelIndex = v
					break
				elseif v == oldIndex then
					found = true
				end

				if not self.apparelIndex then self.apparelIndex = v end
			end

			Events:Fire("SetApparel", {
				slot = self.slot,
				apparel = self.apparelIndex
			})
		elseif args.key == VirtualKey.Left then
			local lastIndex = nil
			local nextIndex = {}
			local oldIndex = self.apparelIndex
			self.apparelIndex = nil

			for k, v in pairs(self.registeredApparel) do
				if lastIndex then
					nextIndex[lastIndex] = v
				end
				
				lastIndex = v
				self.apparelIndex = v
			end

			for k, v in pairs(self.registeredApparel) do
				if oldIndex == nextIndex[v] then
					self.apparelIndex = v
					break
				end
			end

			Events:Fire("SetApparel", {
				slot = self.slot,
				apparel = self.apparelIndex
			})
		elseif args.key == VirtualKey.Down then
			self.slot = (self.slot - 1)
			self.slot = self.slot > 0 and self.slot or 4
			self.apparelIndex = self.playerApparel[self.slot] or 0
		elseif args.key == VirtualKey.Up then
			self.slot = (self.slot + 1)%5
			self.slot = self.slot > 0 and self.slot or 1
			self.apparelIndex = self.playerApparel[self.slot] or 0
		elseif args.key == VirtualKey.Back then
			self.apparelIndex = 0
			Events:Fire("SetApparel", {
				slot = self.slot,
				apparel = nil
			})
		end
	end
end

function ApparelExample:Render()
	if not self.editing then return end

	local text = "Slot: " .. self.slot
	local textSize = Render:GetTextSize(text)
	Render:DrawText(Vector2((Render.Width - textSize.x) / 2, Render.Height - textSize.y - 45), text, Color.Yellow)	

	text = "Item: " .. self.apparelIndex
	textSize = Render:GetTextSize(text)
	Render:DrawText(Vector2((Render.Width - textSize.x) / 2, Render.Height - textSize.y - 30), text, Color.Yellow)

	text = "Editing Apparel"
	textSize = Render:GetTextSize(text)
	Render:DrawText(Vector2((Render.Width - textSize.x) / 2, Render.Height - textSize.y - 15), text, Color.Yellow)
end

apparelexamplemodule = ApparelExample()