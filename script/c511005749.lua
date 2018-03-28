--Spike Seadra (DOR)
--scripted by GameMaster(GM)
function c511005749.initial_effect(c)
--atk/def 300 x # thunder monsters
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005749,1))
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetOperation(c511005749.op)
c:RegisterEffect(e1)
end

function c511005749.filter(c)
return c:IsRace(RACE_THUNDER)
end

function c511005749.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local ct,g=Duel.GetMatchingGroupCount(c511005749.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*300
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(ct)
e1:SetReset(RESET_EVENT+0x1fe0000)
c:RegisterEffect(e1) 
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e2)
end



