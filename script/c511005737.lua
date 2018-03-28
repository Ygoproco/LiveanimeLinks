--Regenerative Rose (Anime)
--by CyberCatman
--edited/fixed by GameMaster(GM)
function c511005737.initial_effect(c)
--rose token
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(31986288,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_BATTLE_DESTROYED)
e1:SetCondition(c511005737.condition)
e1:SetTarget(c511005737.target)
e1:SetOperation(c511005737.operation)
c:RegisterEffect(e1)
--atk gain
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE)
e2:SetCode(EFFECT_UPDATE_ATTACK)
e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e2:SetRange(LOCATION_MZONE)
e2:SetValue(c511005737.adval)
c:RegisterEffect(e2)
end

function c511005737.condition(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end

function c511005737.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
and Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,0x4011,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK) end
Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end

function c511005737.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
if not Duel.IsPlayerCanSpecialSummonMonster(tp,31986289,0,0x4011,1200,1200,3,RACE_PLANT,ATTRIBUTE_DARK) then return end
for i=1,2 do
local token=Duel.CreateToken(tp,31986289)
Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
end
Duel.SpecialSummonComplete()
end

function c511005737.adval(e,c)
if  Duel.GetAttacker()==nil or Duel.GetAttackTarget()==nil then return end	
local ph=Duel.GetCurrentPhase()
local c=e:GetHandler()
local a=Duel.GetAttacker()
local d=Duel.GetAttackTarget()
if ph==PHASE_DAMAGE_CAL and a:IsPosition(POS_FACEUP_ATTACK) and d:IsPosition(POS_FACEUP_ATTACK) then
if a==c then return d:GetAttack() end
if d==c then return a:GetAttack() end
if not a==c and not d==c then return 0 end
end
if not ph==PHASE_DAMAGE_CAL or not (a:IsPosition(POS_FACEUP_ATTACK) and d:IsPosition(POS_FACEUP_ATTACK)) then return 0 end
end