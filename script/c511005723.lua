--Happy Lover (DOR)
--scripted by GameMaster (GM)
function c511005723.initial_effect(c)
	--atk/def reset
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
e1:SetRange(LOCATION_MZONE)
e1:SetCondition(c511005723.atkcon)
e1:SetOperation(c511005723.atkop)
c:RegisterEffect(e1)
end

function c511005723.atkcon(e,tp,eg,ep,ev,re,r,rp)
local a=Duel.GetAttacker()
local d=Duel.GetAttackTarget()
return (a:GetControler()==tp and a:IsRelateToBattle() and d:GetAttack()~=d:GetBaseAttack()) or (d and d:GetControler()==tp and d:IsRelateToBattle() and a:GetAttack()~=a:GetBaseAttack()) or (a:GetControler()==tp and a:IsRelateToBattle() and d:GetAttack()~=d:GetBaseDefense())
	or (d and d:GetControler()==tp and d:IsRelateToBattle() and a:GetDefense()~=a:GetBaseDefense())
end

function c511005723.atkop(e,tp,eg,ep,ev,re,r,rp)
local atk=0
if e:GetHandler()==Duel.GetAttacker() then
local bc=Duel.GetAttackTarget()	
if(bc:GetBaseAttack()>bc:GetAttack()) then
atk=bc:GetBaseAttack()-bc:GetAttack()
else
atk=bc:GetAttack()>bc:GetBaseAttack()
end
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_ATTACK_FINAL)
e1:SetReset(RESET_EVENT+0x1fe0000)
e1:SetValue(bc:GetBaseAttack())
bc:RegisterEffect(e1)
else
local bc=Duel.GetAttacker()	
if(bc:GetBaseAttack()>bc:GetAttack()) then
atk=bc:GetBaseAttack()-bc:GetAttack()
else
atk=bc:GetAttack()>bc:GetBaseAttack()
end
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_ATTACK_FINAL)
e1:SetReset(RESET_EVENT+0x1fe0000)
e1:SetValue(bc:GetBaseAttack())
bc:RegisterEffect(e1)
end
------------------------
local def=0
if e:GetHandler()==Duel.GetAttacker() then
local bc=Duel.GetAttackTarget()	
if(bc:GetBaseDefense()>bc:GetDefense()) then
def=bc:GetBaseDefense()-bc:GetDefense()
else
def=bc:GetDefense()>bc:GetBaseDefense()
end
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
e1:SetReset(RESET_EVENT+0x1fe0000)
e1:SetValue(bc:GetBaseDefense())
bc:RegisterEffect(e1)
else
local bc=Duel.GetAttacker()	
if(bc:GetBaseDefense()>bc:GetDefense()) then
def=bc:GetBaseDefense()-bc:GetDefense()
else
def=bc:GetDefense()>bc:GetBaseDefense()
end
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
e1:SetReset(RESET_EVENT+0x1fe0000)
e1:SetValue(bc:GetBaseDefense())
bc:RegisterEffect(e1)
end
end
