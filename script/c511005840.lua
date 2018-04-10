--Magical white Hat (DOR)
--scripted by GameMaster(GM)
function c511005840.initial_effect(c)
--opps traps cant activate when this card attacks
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_ATTACK_ANNOUNCE)
e1:SetOperation(c511005840.atkop)
c:RegisterEffect(e1)
end

function c511005840.atkop(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e1:SetCode(EFFECT_CANNOT_ACTIVATE)
e1:SetTargetRange(0,1)
e1:SetValue(c511005840.aclimit)
e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
Duel.RegisterEffect(e1,tp)
end

function c511005840.aclimit(e,re,tp)
return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
