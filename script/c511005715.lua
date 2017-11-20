--Mermaid Shark (Anime)
--scripted by GameMaster(GM)
function c511005715.initial_effect(c)
--summon eff 
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_SUMMON_SUCCESS)
e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
e1:SetCondition(c511005715.condition)
e1:SetOperation(c511005715.operation)
c:RegisterEffect(e1)
end

function c511005715.filter2(c)
return (c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x547)) 
end

function c511005715.condition(e,c)
return Duel.IsExistingMatchingCard(c511005715.filter2,e:GetHandler():GetControler(),LOCATION_DECK,0,1,nil)
end

function c511005715.operation(e,tp,eg,ep,ev,re,r,rp,chk)	
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
local g=Duel.SelectMatchingCard(tp,c511005715.filter2,tp,LOCATION_DECK,0,1,1,nil)
Duel.SendtoHand(g,tp,REASON_EFFECT)
Duel.ConfirmCards(1-tp,g)
end

