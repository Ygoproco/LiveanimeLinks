--SwordStalker (DOR)
--scripted by GameMaster(GM)
function c511005729.initial_effect(c)
--atk/def up x # monsters in grave by 100
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005729,1))
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_FLIP)
e1:SetOperation(c511005729.op)
c:RegisterEffect(e1)
end

function c511005729.filter(c)
return c:IsType(TYPE_MONSTER)
end

function c511005729.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local ct,g=Duel.GetMatchingGroupCount(c511005729.filter,tp,LOCATION_GRAVE,0,nil)*100
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(ct)
c:RegisterEffect(e1) 
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e2)
end



