class "Apparel"

function Apparel:__init()
	self.apparel = {}
	self.playerApparel = {}

	Events:Subscribe("FetchRegisteredApparel", self, self.FetchRegisteredApparel)
	Events:Subscribe("FetchPlayerApparel", self, self.FetchPlayerApparel)
	Events:Subscribe("SetApparel", self, self.SetApparel)
	Events:Subscribe("ModulesLoad", self, self.HelpAddItem)
	Events:Subscribe("ModuleLoad", self, self.ModuleLoad)
	Events:Subscribe("ModuleUnload", self, self.ModuleUnload)
	Events:Subscribe("Render", self, self.Render)
	Events:Subscribe("EntitySpawn", self, self.EntitySpawn)
	Events:Subscribe("EntityDespawn", self, self.EntityDespawn)
	Network:Subscribe("ApparelLoad", self, self.ApparelLoad)
end

function Apparel:HelpAddItem()
	Events:Fire("HelpAddItem", {
		name = "Apparel",
		text = "This server uses Apparel by SK83RJOSH.\n" ..
			   "Check it out on GitHub! (http://github.com/SK83RJOSH/Apparel/)"
	})
end

function Apparel:RemoveApparel(player)
	if self.playerApparel[player] then
		for k, v in pairs(self.playerApparel[player]) do
			v:Remove()
		end

		self.playerApparel[player] = nil
	end
end

function Apparel:FetchRegisteredApparel(args)
	local registered = {}
	for k, v in pairs(ApparelBase.RegisteredApparel) do table.insert(registered, k) end

	Events:Fire("RegisteredApparel", {registered = registered})
end

function Apparel:FetchPlayerApparel(args)
	Events:Fire("PlayerApparel", {apparel = self.apparel})
end

function Apparel:SetApparel(args)
	local slot = args.slot
	local apparel = args.apparel

	if not self.playerApparel[LocalPlayer:GetId()] then
		self.playerApparel[LocalPlayer:GetId()] = {}
	elseif self.playerApparel[LocalPlayer:GetId()][slot] then
		self.playerApparel[LocalPlayer:GetId()][slot]:Remove()
		self.playerApparel[LocalPlayer:GetId()][slot] = nil
	end

	if apparel then
		self.playerApparel[LocalPlayer:GetId()][slot] = ApparelBase.RegisteredApparel[apparel]:CreateInstance(LocalPlayer)
	end
	
	self.apparel[slot] = apparel
	Network:Send("ApparelChanged", {apparel = self.apparel})
	Events:Fire("PlayerApparel", {apparel = self.apparel})
end

function Apparel:ModuleLoad()
	Network:Send("ApparelFetch", {player = LocalPlayer:GetId()})

	for player in Client:GetStreamedPlayers() do
		Network:Send("ApparelFetch", {player = player:GetId()})
	end

	self:HelpAddItem()
end

function Apparel:ModuleUnload()
	for k, v in pairs(self.playerApparel) do
		self:RemoveApparel(k)
	end
	
	Events:Fire("HelpRemoveItem", {
		name = "Apparel"
	})
end

function Apparel:Render()
	for k, v in pairs(self.playerApparel) do
		for k, v in pairs(v) do v:Update() end
	end
end

function Apparel:EntitySpawn(args)
	if args.entity.__type == "Player" then
		Network:Send("ApparelFetch", {player = args.entity:GetId()})
	end
end

function Apparel:EntityDespawn(args)
	if args.entity.__type == "Player" and self.playerApparel[args.entity:GetId()] then
		self:RemoveApparel(args.entity:GetId())
	end
end

function Apparel:ApparelLoad(args)
	self:RemoveApparel(args.player)
	
	if args.player == LocalPlayer:GetId() then
		self.apparel = args.apparel
		Events:Fire("PlayerApparel", {apparel = self.apparel})
	end
	
	self.playerApparel[args.player] = {}
	for k, v in pairs(args.apparel) do
		if ApparelBase.RegisteredApparel[v] then -- Apparel must be valid
			table.insert(self.playerApparel[args.player], ApparelBase.RegisteredApparel[v]:CreateInstance(Player.GetById(args.player)))
		end
	end
end

apparel = Apparel()