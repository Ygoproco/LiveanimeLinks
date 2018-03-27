--Swordsman from a foregin Land DOR
--scripted by GameMaster(GM)
function c511005757.initial_effect(c)
--destroy battled monster
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005757,0))
e1:SetCategory(CATEGORY_DESTROY)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_BATTLE_DESTROYED)
e1:SetCondition(c511005757.condition)
e1:SetTarget(c511005757.target)
e1:SetOperation(c511005757.operation)
c:RegisterEffect(e1)
end

function c511005757.condition(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsReason(REASON_BATTLE)
and e:GetHandler():GetReasonCard():IsRelateToBattle()
end

function c511005757.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local rc=e:GetHandler():GetReasonCard()
Duel.SetTargetCard(rc)
Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end

function c511005757.operation(e,tp,eg,ep,ev,re,r,rp)
local rc=Duel.GetFirstTarget()
if rc:IsRelateToEffect(e) then
Duel.Destroy(rc,REASON_EFFECT)
end
end
