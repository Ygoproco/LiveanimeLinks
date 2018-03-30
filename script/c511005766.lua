--Eye of truth DOR
--scripted by GameMaster(GM)
function c511005766.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005766.target)
e1:SetOperation(c511005766.activate)
c:RegisterEffect(e1)
end

function c511005766.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
Duel.SetTargetPlayer(tp)
end

function c511005766.activate(e,tp,eg,ep,ev,re,r,rp)
local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
if g:GetCount()>0 then
Duel.ConfirmCards(p,g)
end
Duel.ShuffleHand(1-p)
end
