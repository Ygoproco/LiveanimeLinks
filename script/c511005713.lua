--Current Corruption Virus 
--scripted by GameMaster(GM)
function c511005713.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_ATKCHANGE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCost(c511005713.cost)
e1:SetOperation(c511005713.activate)
c:RegisterEffect(e1)
end

--tribute dark monster with 0 def 
function c511005713.costfilter(c)
return c:IsAttribute(ATTRIBUTE_DARK) and c:GetDefense()==0
end

function c511005713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.CheckReleaseGroup(tp,c511005713.costfilter,1,nil) end
local g=Duel.SelectReleaseGroup(tp,c511005713.costfilter,1,1,nil)
Duel.Release(g,REASON_COST)
end

function c511005713.tg123(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetMatchingGroup(c511005713.filter,tp,0,LOCATION_MZONE,nil)
end

function c511005713.filter(c)
return (c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()<=2000 and c:GetCounter(0x1108)==0 )
end
    
function c511005713.activate(e,tp,eg,ep,ev,re,r,rp)
--atk to 0 when summoned
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e1:SetCode(EFFECT_SET_ATTACK_FINAL)
e1:SetTargetRange(0,LOCATION_MZONE)
e1:SetTarget(c511005713.tg123)
e1:SetValue(0)
e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
Duel.RegisterEffect(e1,tp)
local e2=Effect.CreateEffect(e:GetHandler())
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e2:SetTarget(c511005713.tg123)
e2:SetCode(EFFECT_DISABLE)
e2:SetTargetRange(0,LOCATION_MZONE)
e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
Duel.RegisterEffect(e2,tp)
--sets count
local e3=Effect.CreateEffect(e:GetHandler())
e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e3:SetCode(EVENT_PHASE+PHASE_END)
e3:SetCountLimit(1)
e3:SetCondition(c511005713.turncon)
e3:SetOperation(c511005713.turnop)
e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
Duel.RegisterEffect(e3,tp)
e3:SetLabelObject(e1)
e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
c511005713[e:GetHandler()]=e3
--cannot activate monsters in hand
local e5=Effect.CreateEffect(e:GetHandler())
e5:SetType(EFFECT_TYPE_FIELD)
e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e5:SetTargetRange(0,1)
e5:SetCode(EFFECT_CANNOT_ACTIVATE)
e5:SetValue(c511005713.value)
e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
Duel.RegisterEffect(e5,tp)
end

function c511005713.value(e,te,tp)
return  te:GetHandler():IsLocation(LOCATION_HAND) and te:IsActiveType(TYPE_MONSTER)
end

function c511005713.turncon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()~=tp
end

function c511005713.turnop(e,tp,eg,ep,ev,re,r,rp)
local ct=e:GetLabel()
ct=ct+1
e:SetLabel(ct)
e:GetHandler():SetTurnCounter(ct)
if ct==3 then
e:GetLabelObject():Reset()
e:GetOwner():ResetFlagEffect(1082946)
end
end
