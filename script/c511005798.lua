--Dark Energy(DOR)
--scripted by GameMaster (GM)
function c511005798.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005798.target)
e1:SetOperation(c511005798.activate)
c:RegisterEffect(e1)
end

function c511005798.filter(c)
return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end

function c511005798.target(e,tp,eg,ep,ev,re,r,rp,chk)
local tc=Duel.GetFirstTarget()
if chk==0 then return Duel.IsExistingTarget(c511005798.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
Duel.SelectTarget(tp,c511005798.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
end

function c511005798.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e)  then
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(300)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
tc:RegisterEffect(e2)
end
end
