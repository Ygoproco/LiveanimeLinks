--アローザル・ハイドライブ・モナーク
--Rousing Hydradrive Monarch
--Scripted by Playmaker 772211
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--Link summon
	aux.AddLinkProcedure(c,s.mfilter,4)
	c:EnableReviveLimit()
	--Multiple attributes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(0xe)
	c:RegisterEffect(e1)
	--Must summon in attack position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--Change ATK and negate effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(s.atktg)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e6)
	--place hydradrive counters when summoned
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_COUNTER)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(s.ctcon)
	e7:SetTarget(s.cttg)
	e7:SetOperation(s.ctop)
	c:RegisterEffect(e7)
	--Dice
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.tgcon)
	e8:SetCost(s.tgcost)
	e8:SetOperation(s.tgop)
	c:RegisterEffect(e8)
end
function s.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function s.filter(c)
	return c:IsAttribute(c:GetAttribute())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(s.filter,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.filter,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,e)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function s.atktg(e,c)
	return c~=e:GetHandler() and e:GetHandler():IsAttribute(c:GetAttribute())
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x577)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x577,4)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local dice=Duel.TossDice(tp,1)
	if dice==1 then
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_EARTH)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	elseif dice==2 then
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_WATER)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	elseif dice==3 then
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_FIRE)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	elseif dice==4 then
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_WIND)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	elseif dice==5 then
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_LIGHT)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	else
	    local sg=Duel.GetMatchingGroup(Card.IsAttribute,tp,0,LOCATION_MZONE,nil,ATTRIBUTE_DARK)
	    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	    if ct>0 then
		    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	end
end