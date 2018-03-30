--Rain of Mercy (DOR)
--scripted by GameMaster (GM)
function c511005771.initial_effect(c)
--All plant race monsters gain 600 atk
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetTarget(c511005771.act_tg)
e1:SetOperation(c511005771.act_op)
c:RegisterEffect(e1)
end

function c511005771.act_fil(c)
return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c511005771.act_tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c511005771.act_fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,nil,0,0,0)
end

function c511005771.act_op(e,tp,eg,ep,ev,re,r,rp)
local tg=Duel.GetMatchingGroup(c511005771.act_fil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
if tg:GetCount()>0 then
local tc=tg:GetFirst()
local c=e:GetHandler()
while tc do
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(600)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
tc:RegisterEffect(e2)
tc=tg:GetNext()
end
end
end