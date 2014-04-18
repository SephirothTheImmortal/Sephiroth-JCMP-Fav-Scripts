local JSON = require("JSON")

class "Apparel"

function Apparel:__init()
	self.apparel = {}

	Events:Subscribe("ModuleLoad", self, self.ModuleLoad)
	Events:Subscribe("PlayerJoin", self, self.PlayerJoin)
	Events:Subscribe("PlayerQuit", self, self.PlayerQuit)
	Network:Subscribe("ApparelFetch", self, self.ApparelFetch)
	Network:Subscribe("ApparelChanged", self, self.ApparelChanged)
end

function Apparel:LoadApparel(player)
	if not table.find(io.files("userdata/"), player:GetSteamId().id .. ".json") then
		apparelFile = io.open("userdata/" .. player:GetSteamId().id .. ".json", "w")
		apparelFile:write(JSON.encode({}))
		apparelFile:close()
	end

	apparelFile = io.open("userdata/" .. player:GetSteamId().id .. ".json", "r")
	self.apparel[player:GetId()] = JSON.decode(apparelFile:read())
	apparelFile:close()
end

function Apparel:SaveApparel(player)
	apparelFile = io.open("userdata/" .. player:GetSteamId().id .. ".json", "w")
	apparelFile:write(JSON.encode(self.apparel[player:GetId()]))
	apparelFile:close()
end

function Apparel:ModuleLoad()
	if not table.find(io.directories("/"), "userdata") then
		io.createdir("userdata/")
	end

	for player in Server:GetPlayers() do
		self:LoadApparel(player)
	end
end

function Apparel:PlayerJoin(args)
	self:LoadApparel(args.player)
end

function Apparel:PlayerQuit(args)
	self.apparel[args.player:GetId()] = nil
end

function Apparel:ApparelFetch(args, sender)
	Network:Send(sender, "ApparelLoad", {player = args.player, apparel = self.apparel[args.player]})
end

function Apparel:ApparelChanged(args, sender)
	self.apparel[sender:GetId()] = args.apparel
	Network:SendNearby(sender, "ApparelLoad", {player = sender:GetId(), apparel = self.apparel[sender:GetId()]})
	self:SaveApparel(sender)
end

apparel = Apparel()