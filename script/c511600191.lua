--エクシーズ・ウイング
--XYZ Wings
--scripted by Larry126
function c511600191.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_XYZ))
	--twice per turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetEquipTarget():GetFlagEffect(511600191)>0 end)
	e1:SetOperation(c511600191.tptop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1918087,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(c511600191.filter,1,nil,e:GetHandler():GetEquipTarget()) end)
	e2:SetTarget(c511600191.damtg)
	e2:SetOperation(c511600191.damop)
	c:RegisterEffect(e2)
	--Halve Battle Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetOperation(c511600191.bdop)
	c:RegisterEffect(e3)
	if not c511600191.global_check then
		c511600191.global_check=true
		OPTEffs={}
		AffectedEffs={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c511600191.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511600191.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511600191.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsHasEffect(511002571) or re:IsHasProperty(EFFECT_FLAG_NO_TURN_RESET) then return end
	local effs={rc:GetCardEffect(511002571)}
	local chk=true
	for _,eff in ipairs(effs) do
		if eff:GetLabelObject()==re then
			chk=false
		end
	end
	if chk then return end
	local _,ctmax,ctcode=re:GetCountLimit()
	if ctcode&~EFFECT_COUNT_CODE_SINGLE>0 or ctmax~=1 then return end
	if rc:GetFlagEffect(511600191)==0 then
		OPTEffs[rc]={}
		AffectedEffs[rc]={}
		rc:RegisterFlagEffect(511600191,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	for _,te in ipairs(OPTEffs[rc]) do
		if te==re then return end
	end
	table.insert(OPTEffs[rc],re)
	if ctcode&EFFECT_COUNT_CODE_SINGLE>0 then
		for _,eff in ipairs(effs) do
			local te=eff:GetLabelObject()
			local _,_,ctlcode=te:GetCountLimit()
			if ctlcode&EFFECT_COUNT_CODE_SINGLE>0 then
				local chk=true
				for _,te2 in ipairs(OPTEffs[rc]) do
					if te==te2 then chk=false end
				end
				if chk then
					table.insert(OPTEffs[rc],te)
				end
			end
		end
	end
end
function c511600191.clear(e,tp,eg,ep,ev,re,r,rp)
	OPTEffs={}
	for _,c in pairs(AffectedEffs) do
		for _,te in ipairs(c) do
			local _,_,ctcode=te:GetCountLimit()
			if ctcode&EFFECT_COUNT_CODE_SINGLE>0 then
				te:SetCountLimit(1,ctcode)
			end
		end
	end
	AffectedEffs={}
end
function c511600191.tptop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipTarget()
	for _,te in ipairs(OPTEffs[eqc]) do
		local chk=true
		for _,te2 in ipairs(AffectedEffs[eqc]) do
			if te2==te then chk=false end
		end
		if chk then
			local _,ctmax,ctcode=te:GetCountLimit()
			if ctcode&EFFECT_COUNT_CODE_SINGLE>0 then
				te:SetCountLimit(ctmax+1,ctcode)
			else
				te:SetCountLimit(ctmax,ctcode)
			end
			table.insert(AffectedEffs[eqc],te)
		end
	end
end
function c511600191.filter(c,eqc)
	return c:GetPreviousTypeOnField()&TYPE_MONSTER==TYPE_MONSTER
		and (c:GetReasonCard()==eqc or c:GetReasonEffect() and c:GetReasonEffect():GetHandler()==eqc)
end
function c511600191.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c511600191.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c511600191.bdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c511600191.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c511600191.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return math.floor(dam/2)
	else return dam end
end