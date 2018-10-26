--天火の牢獄
--Fire Prison (Anime)
--scripted by Larry126
function c511600022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--indestructible
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c511600022.efilter)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c511600022.attg)
	c:RegisterEffect(e4)
	--cannot summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c511600022.sumlimit)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(35952884,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c511600022.condition)
	e6:SetOperation(c511600022.operation)
	c:RegisterEffect(e6)
end
function c511600022.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE)
end
function c511600022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511600022.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c511600022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511600022.cyberse,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:KeepAlive()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_DISABLE_EFFECT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetLabelObject(g)
	e6:SetOperation(c511600022.lvop)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(511600022)
	e7:SetRange(LOCATION_FZONE)
	e7:SetReset(RESET_EVENT+0x1fe0000)
	e7:SetOperation(c511600022.op)
	c:RegisterEffect(e7)
end
function c511600022.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c511600022.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(eg) do
		if g:IsContains(tc) then
			g:RemoveCard(tc)
		end
	end
	if g:GetCount()<=0 and e:GetHandler():GetFlagEffect(511600022)==0 then
		Duel.RaiseEvent(g,511600022,e,0,0,tp,0)
		e:GetHandler():RegisterFlagEffect(511600022,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c511600022.cyberse(c)
	return c:IsRace(RACE_CYBERSE) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
------------------------------------
function c511600022.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function c511600022.sumlimit(e,c,tp,sumtp,sumpos)
	local g=Duel.GetMatchingGroup(c511600022.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg,link=g:GetMaxGroup(Card.GetLink)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK and c:GetLink()<link
end
------------------------------------
function c511600022.attg(e,c)
	return not c:IsType(TYPE_LINK)
end
------------------------------------
function c511600022.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end