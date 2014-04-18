class "ApparelBase"

ApparelBase.Templates = {
	Head = {
		position = Vector3(0, -1.64, -0.04),
		bone = "ragdoll_Head"
	},
	Torso = {
		position = Vector3(0, -1.248, -0.04),
		bone = "ragdoll_Spine1"
	},
	Hips = {
		position = Vector3(0, -0.9, -0.04),
		bone = "ragdoll_Hips"
	},
	Orbit = {
		position = Vector3(0, 0, -0.01),
		bone = "ragdoll_Head",
		tick = function(instance)
			instance.rotation = (instance.rotation or 0) + math.rad(2)
			local nextPos = Vector3(0.5 * math.cos(instance.rotation), 0, 0.5 * math.sin(instance.rotation))
			local direction = nextPos - Vector3(0.5 * math.cos(instance.rotation - math.rad(2)), 0, 0.5 * math.sin(instance.rotation - math.rad(2)))
			local heading = math.atan2(direction.x, -direction.z)
		
			instance.object:SetAngle(Angle(-heading, 0, 0))
			instance.object:SetPosition(instance.object:GetPosition() + nextPos)
		end
	},
	Flaming = {
		position = Vector3(0, -1.64, -0.04),
		bone = "ragdoll_Head",
		tick = function(instance)
			if not instance.effect then
				instance.effect = ClientEffect.Create(AssetLocation.Game, {
					effect_id = 326,
					position = instance.object:GetPosition() - (instance.object:GetAngle() * Vector3(0, -1.64, -0.04)) - Vector3(0, 0, -0.05),
					angle = Angle()
				})
			else
				if not instance.effect:IsPlaying() then
					instance.effect:Play()
				end

				instance.effect:SetPosition(instance.object:GetPosition() - (instance.object:GetAngle() * Vector3(0, -1.64, -0.04)))
			end
		end,
		removal = function(instance)
			if instance.effect then
				instance.effect:Remove()
			end
		end
	}
}

function ApparelBase:__init(model, template)
	self.model = model
	self.template = template
end

function ApparelBase:CreateInstance(player)
	return ApparelInstance(self, player)
end

ApparelBase.RegisteredApparel = {
	["Blackmarket Scarf"] = ApparelBase("pd_blackmarket.eez/pd_blackmarket-scarf.lod", ApparelBase.Templates.Head),
	["Red Beret With Sunglasses"] = ApparelBase("pd_gov_base01.eez/pd_gov_base-beretng.lod", ApparelBase.Templates.Head),
	["Red Beret"] = ApparelBase("pd_gov_base01.eez/pd_gov_base-beret.lod", ApparelBase.Templates.Head),
	["Government Cap With Sunglasses"] = ApparelBase("pd_gov_base01.eez/pd_gov_base-hatng.lod", ApparelBase.Templates.Head),
	["Government Cap"] = ApparelBase("pd_gov_base01.eez/pd_gov_base-hat.lod", ApparelBase.Templates.Head),
	["Military Backpack"] = ApparelBase("pd_gov_base01.eez/pd_gov_base-bags.lod", ApparelBase.Templates.Torso),
	["Flight Helmet"] = ApparelBase("pd_gov_elite.eez/pd_govnewfix_elite-helmet.lod", ApparelBase.Templates.Head),
	["Gray Bandana With Black Stripes"] = ApparelBase("pd_ms_doorman.eez/pd_doorman-h_bandana.lod", ApparelBase.Templates.Head),
	["White Bandana"] = ApparelBase("pd_generic_male_2.eez/pd_generic_male_2-hat_linen.lod", ApparelBase.Templates.Head),
	["Japanese Hat"] = ApparelBase("pd_ms_japaneseveterans.eez/pd_ms_japaneseveterans-hat.lod", ApparelBase.Templates.Head),
	["Japanese Helmet"] = ApparelBase("pd_ms_japaneseveterans.eez/pd_ms_japaneseveterans-helmet.lod", ApparelBase.Templates.Head),
	["Police Cap"] = ApparelBase("pd_panaupolice.eez/panaupolice-cap.lod", ApparelBase.Templates.Head),
	["Police Helmet"] = ApparelBase("pd_panaupolice.eez/panaupolice-helmet.lod", ApparelBase.Templates.Head),
	["Police Turban"] = ApparelBase("pd_panaupolice.eez/panaupolice-turban.lod", ApparelBase.Templates.Head),
	["Scientist Glasses"] = ApparelBase("pd_ms_scientist_male.eez/pd_ms_scientists-glasses.lod", ApparelBase.Templates.Head),
	["Thug Glasses"] = ApparelBase("pd_thugs1.eez/pd_thugs-o_glasses.lod", ApparelBase.Templates.Head),
	["Ular Glasses"] = ApparelBase("pd_ularboyselite1.eez/pd_ularboys_elite_male-glasses.lod", ApparelBase.Templates.Head),
	["Felt Fedora"] = ApparelBase("pd_thugs1.eez/pd_thugs-h_felthat.lod", ApparelBase.Templates.Head),
	["Sunglasses"] = ApparelBase("pd_blackhand.eez/pd_blackhand-glasses.lod", ApparelBase.Templates.Head),
	["Gold Beret"] = ApparelBase("pd_reaperselite1.eez/pd_reapers_elite_male-beret.lod", ApparelBase.Templates.Head),
	["Black Kepi"] = ApparelBase("pd_reaperselite1.eez/pd_reapers_elite_male-cap.lod", ApparelBase.Templates.Head),
	["Gray Kepi With Wig"] = ApparelBase("pd_tourist_female1.eez/pd_tourist_female-h_keps.lod", ApparelBase.Templates.Head),
	["Wig With Sunglasses"] = ApparelBase("pd_tourist_female1.eez/pd_tourist_female-h_sunglasses.lod", ApparelBase.Templates.Head),
	["Fisherman's Hat With Wig"] = ApparelBase("pd_tourist_female1.eez/pd_tourist_female-h_fisherhat.lod", ApparelBase.Templates.Head),
	["Gray Kepi"] = ApparelBase("pd_oilplatform_male1.eez/pd_oilplatform_male-greycap.lod", ApparelBase.Templates.Head),
	["Ushanka"] = ApparelBase("pd_arcticvillage_male1.eez/pd_arcticvillage_male-hat.lod", ApparelBase.Templates.Head),
	["White Hijab"] = ApparelBase("pd_desertvillage_female1.eez/pd_desertvillage_female-shawl.lod", ApparelBase.Templates.Head),
	["Desert Turban"] = ApparelBase("pd_desertvillage_male1.eez/pd_desertvillage_male-turban.lod", ApparelBase.Templates.Head),
	["General's Hat"] = ApparelBase("pd_ms_civ_strippers_female1.eez/pd_civilian_stripper_female-ht_militarycap.lod", ApparelBase.Templates.Head),
	["Trilby"] = ApparelBase("pd_ms_civ_strippers_male1.eez/pd_civilian_stripper_male-hat.lod", ApparelBase.Templates.Head),
	["Cowboy Hat"] = ApparelBase("pd_ms_civ_strippers_male2.eez/pd_civilian_stripper_male-cowboyhat.lod", ApparelBase.Templates.Head),
	["Red Bandana Around Neck"] = ApparelBase("pd_ms_civ_strippers_male2.eez/pd_civilian_stripper_male-cowboyscarf.lod", ApparelBase.Templates.Head),
	["White Turban"] = ApparelBase("pd_generic_female_2.eez/pd_generic_female_2-hat_towel.lod", ApparelBase.Templates.Head),
	["White Turban (Dirty)"] = ApparelBase("pd_generic_female_3.eez/pd_generic_female_3-hat_towel.lod", ApparelBase.Templates.Head),
	["Patterned Bandana"] = ApparelBase("pd_generic_female_5.eez/pd_generic_female_5-hat_cloth.lod", ApparelBase.Templates.Head),
	["Black Hijab"] = ApparelBase("pd_generic_female_5.eez/pd_generic_female_5-hat_scarf.lod", ApparelBase.Templates.Head),
	["Straw Hat"] = ApparelBase("pd_generic_female_5.eez/pd_generic_female_5-hat_straw2.lod", ApparelBase.Templates.Head),
	["Rice Hat Without Straps"] = ApparelBase("pd_generic_male.eez/pd_generic_male-hat.lod", ApparelBase.Templates.Head),
	["Fisherman's Hat"] = ApparelBase("pd_generic_male_1.eez/pd_generic_male_1-hat_fisherman.lod", ApparelBase.Templates.Head),
	["Light-Gray Bandana With White Stripes"] = ApparelBase("pd_generic_male_3.eez/pd_generic_male_3-hat_linen.lod", ApparelBase.Templates.Head),
	["Light-Gray Bandana With Black Stripes"] = ApparelBase("pd_generic_male_1.eez/pd_generic_male_1-hat_linen.lod", ApparelBase.Templates.Head),
	["Rice Hat"] = ApparelBase("pd_generic_male_1.eez/pd_generic_male_1-hat_rice.lod", ApparelBase.Templates.Head),
	["Weird Hat"] = ApparelBase("pd_generic_male_2.eez/pd_generic_male_2-hat_weird.lod", ApparelBase.Templates.Head),
	["Fedora"] = ApparelBase("pd_generic_male_2.eez/pd_generic_male_2-hat_fedora.lod", ApparelBase.Templates.Head),
	["Ular Backpack"] = ApparelBase("pd_ularboysbase1.eez/pd_ularboys_base_male-backpack.lod", ApparelBase.Templates.Torso),
	["Canteen"] = ApparelBase("pd_ularboysbase1.eez/pd_ularboys_base_male-waterbottle.lod", ApparelBase.Templates.Hips),
	["Orbiting Bird"] = ApparelBase("cutscene_bird_skinned.eez/cutscene_bird-base1.lod", ApparelBase.Templates.Orbit),
	["Orbiting Fish"] = ApparelBase("general.blz/critfish02-body.lod", ApparelBase.Templates.Orbit),
	["Orbiting Fish 2"] = ApparelBase("general.blz/critfish03-body.lod", ApparelBase.Templates.Orbit),
	["Orbiting Scorpion"] = ApparelBase("general.blz/critscorpion-body.lod", ApparelBase.Templates.Orbit),
	["Orbiting Screw"] = ApparelBase("general.blz/debriscar-screw.lod", ApparelBase.Templates.Orbit),
	["Orbiting Light"] = ApparelBase("general.blz/vehicle_light-light1.lod", ApparelBase.Templates.Orbit),
	["Unusual Ushanka"] = ApparelBase("pd_arcticvillage_male1.eez/pd_arcticvillage_male-hat.lod", ApparelBase.Templates.Flaming),
	["Spinning Globe"] = ApparelBase("km07.submarine.eez/key014_02-globesphere.lod", {
		position = Vector3(0, 0.6, 0),
		bone = "ragdoll_Head",
		tick = function(instance)
			instance.rotation = (instance.rotation or 0) + math.rad(1)
			instance.object:SetAngle(instance.object:GetAngle() * Angle(instance.rotation, 0, 0))
		end
	}),
	["Spinning Rotor"] = ApparelBase("arve.v009_military_helicopter.eez/v009mil-rotor1-rotorstilltail.lod", {
		position = Vector3(0, 0.2, 0),
		bone = "ragdoll_Head",
		tick = function(instance)
			instance.rotation = (instance.rotation or 0) + math.rad(10)
			instance.object:SetAngle(instance.object:GetAngle() * Angle(0, instance.rotation, math.rad(90)))
		end
	}),
	["Platinum Bolt"] = ApparelBase("general.blz/debriscar-screw.lod", {
		position = Vector3(0, 0.3, 0),
		bone = "ragdoll_Head",
		tick = function(instance)
			instance.rotation = (instance.rotation or 0) + math.rad(1)
			instance.object:SetAngle(instance.object:GetAngle() * Angle(0, instance.rotation, -instance.rotation))
		end
	})
}

class "ApparelInstance" (ApparelBase)

function ApparelInstance:__init(base, player)
	ApparelBase.__init(self, base.model, base.template)
	self.player = player

	self.object = ClientStaticObject.Create({
		position = self.player:GetBonePosition(self.template.bone) + (self.player:GetBoneAngle(self.template.bone) * self.template.position),
		angle = self.player:GetBoneAngle(self.template.bone),
		model = self.model
	})
end

function ApparelInstance:Update()
	self.object:SetPosition(self.player:GetBonePosition(self.template.bone) + (self.player:GetBoneAngle(self.template.bone) * self.template.position))
	self.object:SetAngle(self.player:GetBoneAngle(self.template.bone))

	if self.template.tick then
		self.template.tick(self)
	end
end

function ApparelInstance:Remove()
	self.object:Remove()

	if self.template.removal then
		self.template.removal(self)
	end
end