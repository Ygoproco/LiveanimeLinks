--Dark Elf (DOR)
--scripted by GameMaster(GM)
function c511005722.initial_effect(c)
--attack cost
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_ATTACK_COST)
e1:SetCost(c511005722.atcost)
e1:SetOperation(c511005722.atop)
c:RegisterEffect(e1)
end

function c511005722.atcost(e,c,tp)
return Duel.CheckLPCost(tp,50)
end

function c511005722.atop(e,tp,eg,ep,ev,re,r,rp)
Duel.PayLPCost(tp,50)
end
