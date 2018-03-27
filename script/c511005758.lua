--Barrel Dragon (DOR)
--scripted by GameMaster (GM)
function c511005758.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_DESTROY+CATEGORY_FLIP)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetTarget(c511005758.target)
e1:SetOperation(c511005758.activate)
c:RegisterEffect(e1)
end

function c511005758.filter(c,e)
return c:IsType(0xfff) and not c:IsImmuneToEffect(e) 
end

function c511005758.target(e,tp,eg,ep,ev,re,r,rp,chk)
local oppmonNum = Duel.GetMatchingGroupCount(c511005758.filter,nil,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
local s1=math.min(oppmonNum,oppmonNum)
if chk==0 then return Duel.IsExistingTarget(c511005758.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),e)  end
local g=Duel.GetMatchingGroup(c511005758.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
if g:GetCount()>0  then
local tg=g
if tg:GetCount()>1 then
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
Duel.SetTargetCard(tg)
Duel.HintSelection(g)
end
end
end

function c511005758.activate(e,tp,eg,ep,ev,re,r,rp)
local oppmonNum = Duel.GetMatchingGroupCount(c511005758.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
local s1=math.min(oppmonNum,oppmonNum)
local g=Duel.GetMatchingGroup(c511005758.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
if g:GetCount()>0 then
local sg=g:RandomSelect(tp,1)
Duel.Destroy(sg,REASON_EFFECT)
Duel.ConfirmCards(tp,sg)
end
end
