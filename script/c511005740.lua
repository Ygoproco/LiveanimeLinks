--Molten Behemoth (DOR)
--scripted by GameMaster (GM)
function c511005740.initial_effect(c)
--pyro monster boost of 500ATK/DEF
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetRange(LOCATION_MZONE,0)
e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PYRO))
e1:SetTargetRange(LOCATION_MZONE,0)
e1:SetValue(500)
e1:SetCondition(c511005740.con)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e2)
end

function c511005740.con(e)
return e:GetHandler():IsDefensePos()
end

