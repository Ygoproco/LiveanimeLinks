--Injection Fairy Lily (DOR)
--scripted by GameMaster(GM)
function c511005716.initial_effect(c)
--gain 50 lp start of each turn
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_F)
e1:SetCategory(CATEGORY_RECOVER)
e1:SetCode(EVENT_PREDRAW)
e1:SetRange(LOCATION_MZONE)
e1:SetCondition(c511005716.con)
e1:SetOperation(c511005716.op)
e1:SetCountLimit(1)
c:RegisterEffect(e1)
end

function c511005716.con(e,tp,eg,ep,ev,re,r,rp)
return  e:GetHandler():IsDefensePos()
end

function c511005716.op(e,tp,eg,ep,ev,re,r,rp)
Duel.Recover(tp,50,REASON_EFFECT)
end
