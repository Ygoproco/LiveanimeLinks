--Performance of Sword (DOR)
--scripted by GameMaster (GM)
function c511005776.initial_effect(c)
c:EnableReviveLimit()
--atkdef up
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(511005776,0))
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
e1:SetCondition(c511005776.con)
e1:SetOperation(c511005776.op)
c:RegisterEffect(e1)
end

function c511005776.con(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local bc=c:GetBattleTarget()
return bc and bc:IsRace(RACE_WARRIOR)
end

function c511005776.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsRelateToEffect(e) and c:IsFaceup() then
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
e1:SetValue(900)
c:RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e2)
end
end
