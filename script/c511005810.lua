--laughing flower (DOR)
--scripted by GameMaster (GM) + Shad3
function c511005810.initial_effect(c)
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_BE_BATTLE_TARGET)
e1:SetRange(LOCATION_MZONE)
e1:SetCondition(c511005810.con)
e1:SetOperation(c511005810.op)
e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e2:SetCategory(CATEGORY_CONTROL)
e2:SetTarget(c511005810.target)
e2:SetOperation(c511005810.control)
c:RegisterEffect(e2)
e1:SetLabelObject(e2)
end

function c511005810.con(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsPosition(POS_FACEDOWN)
end

function c511005810.op(e,tp,eg,ep,ev,re,r,rp)
local te=e:GetLabelObject()
local tetype=te:GetType()
local tecode=te:GetCode()
te:SetType(EFFECT_TYPE_ACTIVATE)
te:SetCode(EVENT_FREE_CHAIN)
local act=false
if te:IsActivatable(tp) then act=true end
te:SetType(tetype)
te:SetCode(tecode)
if not act then return end
Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
end

function c511005810.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetAttacker() end
Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.GetAttacker(),1,0,0)
end

function c511005810.control(e,tp,eg,ep,ev,re,r,rp)
local bc=Duel.GetAttacker()
if not bc or not bc:IsRelateToBattle() then return end
Duel.NegateAttack()
Duel.GetControl(bc,tp,PHASE_END,1)
end