--Sword of Dragon's Soul (DOR)
--scripted by GameMaster (GM)
function c511005850.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetTarget(c511005850.target)
e1:SetOperation(c511005850.activate)
c:RegisterEffect(e1)
end

function c511005850.filter(c)
return  c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end

function c511005850.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e)  then
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetCategory(CATEGORY_DESTROY)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(EVENT_BATTLE_START)
e1:SetCondition(c511005850.con)
e1:SetTarget(c511005850.destg)
e1:SetOperation(c511005850.desop)
e1:SetReset(RESET_EVENT+0x00040000)
tc:RegisterEffect(e1)
--negate
local e2=Effect.CreateEffect(e:GetHandler())
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EVENT_BATTLED)
e2:SetOperation(c511005850.desop)
tc:RegisterEffect(e2)
end
end


function c511005850.con(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local bc=c:GetBattleTarget()
return bc and bc:IsRace(RACE_DRAGON)
end


function c511005850.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingTarget(c511005850.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
g=Duel.SelectTarget(tp,c511005850.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
if g:GetCount()>0 then
local tg=g
if tg:GetCount()>0 then
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
Duel.SetTargetCard(tg)
Duel.HintSelection(g)
end
end
end

function c511005850.destg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
local bc=c:GetBattleTarget()
if chk==0 then return bc and bc:IsFaceup() and bc:IsRace(RACE_DRAGON) end
Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end

function c511005850.desop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if  Duel.GetAttacker()==nil or Duel.GetAttackTarget()==nil then return end	
local bc=c:GetBattleTarget()
if not bc and bc:IsRace(RACE_DRAGON) then return end
if bc:IsRelateToBattle() and bc:IsRace(RACE_DRAGON) then
Duel.Destroy(bc,REASON_EFFECT)
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_DISABLE)
e1:SetReset(RESET_EVENT+0x17a0000)
bc:RegisterEffect(e1)
local e2=Effect.CreateEffect(e:GetHandler())
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetCode(EFFECT_DISABLE_EFFECT)
e2:SetReset(RESET_EVENT+0x17a0000)
bc:RegisterEffect(e2)
end
end
