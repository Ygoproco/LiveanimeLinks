--Spirit of the Books (DOR)
--scripted by GameMaster(GM)
function c511005792.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005792,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetTarget(c511005792.tg)
e1:SetOperation(c511005792.op)
c:RegisterEffect(e1)
end

function c511005792.filter(c,e,tp)
return c:GetOriginalCode()==511005775 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c511005792.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and Duel.IsExistingMatchingCard(c511005792.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c511005792.op(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,c511005792.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
if g:GetCount()>0 then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
end
end
