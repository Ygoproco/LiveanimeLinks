--Raigeki (DOR)
--scripted by GameMaster(GM)
function c511005783.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_DESTROY)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005783.tg)
e1:SetOperation(c511005783.op)
c:RegisterEffect(e1)
end

function c511005783.filter(c,g)
return g:IsContains(c)
end

function c511005783.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local cg=e:GetHandler():GetColumnGroup()
local g=Duel.GetMatchingGroup(c511005783.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c511005783.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local cg=c:GetColumnGroup()
if c:IsRelateToEffect(e) then
local g=Duel.GetMatchingGroup(c511005783.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
if g:GetCount()>0 then
Duel.Destroy(g,REASON_EFFECT)
end
end
end


