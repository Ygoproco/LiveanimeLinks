--Perfection Hydradrive Dragon
--Scripted by Rundas
local s,id=GetID()
function c511009728.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x9,LOCATION_MZONE)	
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),1)
	--no battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--place counters on summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.countercondition)
	e2:SetTarget(s.countertarget)
	e2:SetOperation(s.counteroperation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.attackvalue)
	c:RegisterEffect(e3)
	--nuke + burn
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetTarget(s.nuketarget)
	e4:SetOperation(s.nukeoperation)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(s.replacetarget)
	e5:SetOperation(s.replaceoperation)
	c:RegisterEffect(e5)
end

--place counters on summon

function s.countercondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end

function s.countertarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,0,0x9)
end

function s.counteroperation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x9,5)
	end
end

--atk up

function s.attackvalue(e,c)
	return c:GetCounter(0x9)*1000
end

--nuke + burn

function s.burnfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x577)
end

function s.nuketarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end

function s.nukeoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Destroy(g,nil,REASON_EFFECT)
	local h=Duel.GetMatchingGroup(s.burnfilter,tp,LOCATION_GRAVE,0,nil)
	if #h>0 then
	Duel.Damage(1-tp,#h*300,REASON_EFFECT)
end
end

--destroy replace

function s.replacetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x9,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end

function s.replaceoperation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x9,1,REASON_EFFECT)
end