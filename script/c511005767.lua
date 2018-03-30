-- The inexperienced spy
-- scripted by GameMaster(GM)
function c511005767.initial_effect(c)
-- confirm
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005767.target)
e1:SetOperation(c511005767.operation)
c:RegisterEffect(e1)
end

function c511005767.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsFacedown() end
if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end

function c511005767.operation(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
if g:GetCount()>0 then
Duel.ConfirmCards(tp,g)
end
end

