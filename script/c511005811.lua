--Greenkappa (DOR)
--scripted by GameMaster (GM)
function c511005811.initial_effect(c)
--atk def
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005811,0))
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
e1:SetCode(EVENT_FLIP)
e1:SetTarget(c511005811.target)
e1:SetOperation(c511005811.operation)
c:RegisterEffect(e1)
end

function c511005811.filter(c)
return c:IsType(TYPE_MONSTER) 
end

function c511005811.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingTarget(c511005811.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

function c511005811.operation(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005811.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
if g:GetCount()>0 then
local tg=g:GetMaxGroup(Card.GetAttack)
local tc=tg:GetFirst()
while tc do
local c=e:GetHandler()
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_ATTACK_FINAL)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
e1:SetValue(tc:GetAttack())
e1:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
e2:SetValue(tc:GetDefense())
e2:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e2)
tc=tg:GetNext()
end
else if tg:GetCount()>1 then
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
local sg=tg:Select(tp,1,1,nil)
Duel.HintSelection(sg)	
local tc=tg:GetFirst()
while tc do
local c=e:GetHandler()
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_SINGLE)
e3:SetCode(EFFECT_SET_ATTACK_FINAL)
e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
e3:SetValue(tc:GetAttack())
e3:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_SINGLE)
e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
e4:SetValue(tc:GetDefense())
e4:SetReset(RESET_EVENT+0x1ff0000)
c:RegisterEffect(e4)
tc=tg:GetNext()
end
end
end
end

