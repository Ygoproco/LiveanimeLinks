--Beautiful Beast Tamer (DOR)
--scripted by GameMaster (GM)
function c511005812.initial_effect(c)
--+300 atk/def beast type monsters
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetOperation(c511005812.operation)
c:RegisterEffect(e1)
end

function c511005812.atktg(e,c)
return Duel.GetMatchingGroup(c511005812.filter,tp,LOCATION_MZONE,0,nil)
end

function c511005812.filter(c)
return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST)
end

function c511005812.operation(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005812.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
local tc=g:GetFirst()
while tc do
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetTarget(c511005812.atktg)
e1:SetReset(RESET_EVENT+0x1fe0000)
e1:SetValue(300)
tc:RegisterEffect(e1) 
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
tc:RegisterEffect(e2)
tc=g:GetNext()
end
end