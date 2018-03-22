--Darkness Approaches
--scripted by GameMaster (GM)
function c511005736.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetOperation(c511005736.op)
e1:SetTarget(c511005736.tg)
c:RegisterEffect(e1)
--cannot turn set
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetCode(EFFECT_CANNOT_TURN_SET)
e2:SetValue(1)
c:RegisterEffect(e2)
end

function c511005736.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end


function c511005736.filter(c)
return c:IsAttackPos() and c:IsFaceup() and c:IsCanTurnSet()
end

function c511005736.filter2(c)
return c:IsDefensePos() and c:IsFaceup() and c:IsCanTurnSet()
end

function c511005736.filter3(c)
return c:IsFaceup() and c:IsCanTurnSet()
end




function c511005736.op(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005736.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
if g:GetCount()>0 then 
Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
end
local g=Duel.GetMatchingGroup(c511005736.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
if g:GetCount()>0 then 
Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
local g=Duel.GetMatchingGroup(c511005736.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
if g:GetCount()>0 then 
Duel.ChangePosition(g,POS_FACEDOWN)
end
end
