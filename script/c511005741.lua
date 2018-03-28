--LaLa Li-oon (DOR)
--scripted by GameMaster (GM)
function c511005741.initial_effect(c)
--atk/DEF down
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetRange(LOCATION_MZONE)
e1:SetTargetRange(0,LOCATION_MZONE)
e1:SetValue(-500)
e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
e1:SetCondition(c511005741.con)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e2)
end


function c511005741.con(e,c)
return e:GetHandler():IsDefensePos() 
end