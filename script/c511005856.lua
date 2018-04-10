--Brain Control (DOR)
--scripted by GameMaster(GM)
function c511005856.initial_effect(c)
--take control opp monster with highest ATK
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_CONTROL)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005856.target)
e1:SetOperation(c511005856.activate)
c:RegisterEffect(e1)
end

function c511005856.filter(c,e,tp)
return c:IsControlerCanBeChanged() and c:IsFaceup()
end

function c511005856.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return  Duel.IsExistingTarget(c511005856.filter,tp,0,LOCATION_MZONE,1,nil) end
local g=Duel.GetMatchingGroup(c511005856.filter,tp,0,LOCATION_MZONE,nil)
if g:GetCount()>0 then
local tg=g:GetMaxGroup(Card.GetAttack) end
return tg 
end

function c511005856.activate(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
local g=Duel.GetMatchingGroup(c511005856.filter,tp,0,LOCATION_MZONE,nil)
if g:GetCount()>0 then
local tg=g:GetMaxGroup(Card.GetAttack)
local tc=tg:GetFirst()
Duel.GetControl(tc,tp,PHASE_END,1)
end
end


