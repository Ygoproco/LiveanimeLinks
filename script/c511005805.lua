--GraveRobber (DOR)
--scripted by GameMaster (GM)
function c511005805.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005805.tg)
e1:SetOperation(c511005805.activate)
c:RegisterEffect(e1)
end

function c511005805.filter(c)
return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end

function c511005805.tg(e,tp,eg,ep,ev,re,r,rp,chk)
local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
if chk==0 then return ft>0
and Duel.IsExistingTarget(c511005805.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
Duel.SelectTarget(tp,c511005805.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end

function c511005805.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e) then
Duel.SSet(tp,tc)
end
end

