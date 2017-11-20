--Last Machine Acid Virus (Anime)
--scripted by GameMaster(GM)
function c513000178.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_DESTROY)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetHintTiming(0,TIMING_TOHAND)
e1:SetCost(c513000178.cost)
e1:SetTarget(c513000178.target)
e1:SetOperation(c513000178.activate)
c:RegisterEffect(e1)
end

function c513000178.costfilter(c)
return c:IsAttribute(ATTRIBUTE_WATER)
end

function c513000178.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.CheckReleaseGroup(tp,c513000178.costfilter,1,nil) end
local g=Duel.SelectReleaseGroup(tp,c513000178.costfilter,1,1,nil)
Duel.Release(g,REASON_COST)
end

function c513000178.tgfilter(c)
return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsDestructable()
end

function c513000178.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local g=Duel.GetMatchingGroup(c513000178.tgfilter,tp,0,LOCATION_MZONE,nil)
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c513000178.filter(c)
return c:IsRace(RACE_MACHINE)
end

function c513000178.activate(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(c513000178.filter,nil)
		Duel.Destroy(dg,REASON_EFFECT)
		local ct=dg:GetCount()*500
		Duel.Damage(1-tp,ct,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(c513000178.desop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c513000178.turncon)
	e2:SetOperation(c513000178.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	c513000178[e:GetHandler()]=e2
end

function c513000178.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(c513000178.filter,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	local ct=dg:GetCount()*500
	Duel.Damage(1-tp,ct,REASON_EFFECT)
	Duel.ShuffleHand(ep)
end

function c513000178.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c513000178.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end
