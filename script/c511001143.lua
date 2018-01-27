--Power Balance
function c511001143.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001143.condition)
	e1:SetTarget(c511001143.target)
	e1:SetOperation(c511001143.activate)
	c:RegisterEffect(e1)
end
function c511001143.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c511001143.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and ct%2==0 and Duel.IsPlayerCanDraw(tp,ct/2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct/2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,tp,0,ct/2)
end
function c511001143.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct%2~=0 then return end
	local dct=Duel.DiscardHand(1-tp,nil,ct/2,ct/2,REASON_EFFECT+REASON_DISCARD)
	if dct==ct/2 then
		Duel.BreakEffect()
		Duel.Draw(tp,dct,REASON_EFFECT)
	end
end
