--デトネイト・デリーター
--Detonate Deleter
--scripted by Larry126
function c511600187.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_CYBERSE),2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c511600187.destg)
	e1:SetOperation(c511600187.desop)
	c:RegisterEffect(e1)
end
function c511600187.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil end
	local g=Duel.GetAttackTarget()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,1-tp,LOCATION_MZONE)
end
function c511600187.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetAttackTarget()
	if g and g:IsRelateToBattle()then
		Duel.Destroy(g,REASON_EFFECT)
	end
end