--Invitiation to a Deep Sleep (DOR)
--scripted by GameMaster (GM)
function c511005853.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_POSITION)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetTarget(c511005853.target)
e1:SetOperation(c511005853.activate)
c:RegisterEffect(e1)
end

function c511005853.filter(c)
return c:IsType(TYPE_MONSTER)
end

function c511005853.filter2(c)
return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
end

function c511005853.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
end

function c511005853.activate(e,tp,eg,ep,ev,re,r,rp)
local sg=Duel.GetMatchingGroup(c511005853.filter,tp,0,LOCATION_MZONE,nil)
local tc=sg:GetFirst()
while tc do
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CANNOT_ATTACK)
e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
tc:RegisterEffect(e1)
local e2=Effect.CreateEffect(e:GetHandler())
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
tc:RegisterEffect(e2)
tc=sg:GetNext()
Duel.BreakEffect()
local sg=Duel.GetMatchingGroup(c511005853.filter2,tp,0,LOCATION_SZONE,nil)
local tc=sg:GetFirst()
while tc do
local e3=Effect.CreateEffect(e:GetHandler())
e3:SetType(EFFECT_TYPE_SINGLE)
e3:SetCode(EFFECT_CANNOT_TRIGGER)
e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
tc:RegisterEffect(e3)
tc=sg:GetNext()
end
end
end
