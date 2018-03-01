--ＳＮｏ．０ ホープ・ゼアル
--Number S0: Utopic ZEXAL (Anime)
--scripted by Larry126
local card=c511600070
local zexal=nil
function f()
end
function card.initial_effect(c)
	zexal=c
	aux.CallToken(420)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,card.xyzfilter,nil,3)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(card.indes)
	c:RegisterEffect(e1)
	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(card.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(card.effcon2)
	e3:SetOperation(card.spsumsuc)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(card.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	if not card.global_check then
		card.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(card.numchk)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCondition(card.con)
		ge2:SetOperation(card.op)
		Duel.RegisterEffect(ge2,0)
	end
end
card.xyz_number=0
function card.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,52653092)
	Duel.CreateToken(1-tp,52653092)
end
function card.con(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		return Duel.IsPlayerAffectedByEffect(i,EFFECT_CANNOT_SPECIAL_SUMMON)
	end
end
function card.splimit(e,c,tp,sumtp,sumpos)
	return f and c~=zexal
end
function card.op(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		local effs={Duel.GetPlayerEffect(i,EFFECT_CANNOT_SPECIAL_SUMMON)}
		for _,eff in ipairs(effs) do
			if eff:GetLabel()~=511600070 then
				f=eff:GetTarget()
				eff:SetTarget(card.splimit)
				eff:SetLabel(511600070)
			end
		end
	end
end
function card.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CANNOT_SPECIAL_SUMMON)
		or Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
end
function card.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsNumberS()
end
function card.effcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL
end
function card.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL
end
function card.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(card.chlimit)
end
function card.chlimit(e,ep,tp)
	return tp==ep
end
function card.atkval(e,c)
	return c:GetOverlayGroup():GetSum(Card.GetRank)*500
end
function card.indes(e,c)
	return not c:IsSetCard(0x48)
end