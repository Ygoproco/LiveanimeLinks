--ＳＮｏ．０ ホープ・ゼアル
--Number S0: Utopic ZEXAL (Manga)
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	aux.CallToken(420)
	aux.CallToken(c:GetOriginalCodeRule())
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,s.xyzfilter,nil,3)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indes)
	c:RegisterEffect(e1)
	--cannot prevent summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(0xff)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--cannot disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(s.effcon)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.effcon)
	e4:SetOperation(s.spsumsuc)
	c:RegisterEffect(e4)
	--atk & def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e6)
end
s.xyz_number=0
s.registeredEffects={}
function s.splimit(tg,zexal)
	return function(e,c,...)
		return c~=zexal and tg(e,c,...)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local zexal=e:GetHandler()
	for i=0,1 do
		local effs={Duel.GetPlayerEffect(i,EFFECT_CANNOT_SPECIAL_SUMMON)}
		for _,eff in ipairs(effs) do
			if not s.registeredEffects[eff] then
				eff:SetTarget(s.splimit(eff:GetTarget(),zexal))
				s.registeredEffects[eff]=true
			end
		end
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsNumberS()
end
function s.indes(e,c)
	return not c:IsSetCard(0x48)
end
function s.atkval(e,c)
	return c:GetOverlayGroup():GetSum(Card.GetRank)*500
end
