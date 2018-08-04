--女神スクルドの託宣 (Anime)
--Goddess Skuld's Oracle (Anime)
--Scripted by Eerie Code
function c511000419.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Re-arrange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100243008,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c511000419.target)
	e2:SetOperation(c511000419.operation)
	c:RegisterEffect(e2)
end
function c511000419.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function c511000419.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SortDecktop(tp,1-tp,3)
end