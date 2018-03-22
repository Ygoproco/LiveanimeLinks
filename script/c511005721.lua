--Stop Defense (DOR)
--scripted by GameMaster (GM)
function c511005721.initial_effect(c)
--Activate
local e0=Effect.CreateEffect(c)
e0:SetCategory(CATEGORY_POSITION)
e0:SetType(EFFECT_TYPE_ACTIVATE)
e0:SetCode(EVENT_FREE_CHAIN)
e0:SetOperation(c511005721.operation)
e0:SetTarget(c511005721.target)
c:RegisterEffect(e0)
end

function c511005721.filter(c)
return c:IsDefensePos() and c:IsFaceup()
end

function c511005721.filter2(c)
return c:IsDefensePos() and c:IsFacedown()
end

function c511005721.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c511005721.filter,tp,0,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(c511005721.filter2,tp,0,LOCATION_MZONE,1,nil) end
local g=Duel.GetMatchingGroup(c511005721.filter,tp,0,LOCATION_MZONE,nil)
Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

function c511005721.operation(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005721.filter,tp,0,LOCATION_MZONE,nil)
if g:GetCount()>0 then 
Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
local g=Duel.GetMatchingGroup(c511005721.filter2,tp,0,LOCATION_MZONE,nil)
if g:GetCount()>0 then 
Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
end
end
