--Mask of Darkness (DOR)
--scripted by GameMaster (GM)
function c511005719.initial_effect(c)
--flip
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_FLIP)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetTarget(c511005719.tg)
e1:SetOperation(c511005719.activate)
c:RegisterEffect(e1)
end

function c511005719.filter(c)
return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function c511005719.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c511005719.filter(chkc) end
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
and Duel.IsExistingTarget(c511005719.filter,tp,LOCATION_GRAVE,0,1,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
Duel.SelectTarget(tp,c511005719.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end

function c511005719.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e) and tc:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
Duel.SSet(tp,tc)
end
end

