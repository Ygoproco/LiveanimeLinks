--Performpal LaughMaker (Anime)
--scripted by GameMaster(GM)
function c511005712.initial_effect(c)
aux.EnablePendulumAttribute(c)
--atk gain 1000 laughmaker gains atk
local e0=Effect.CreateEffect(c)
e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e0:SetCode(511001762)
e0:SetCondition(c511005712.con0)
e0:SetTarget(c511005712.target2)
e0:SetOperation(c511005712.activate2)
e0:SetRange(LOCATION_MZONE)
c:RegisterEffect(e0)
--atk gain 1000 when opp monster gain atk
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(511000377)
e1:SetCondition(c511005712.condition)
e1:SetTarget(c511005712.target)
e1:SetTargetRange(0,LOCATION_MZONE)
e1:SetOperation(c511005712.activate)
e1:SetRange(LOCATION_MZONE)
c:RegisterEffect(e1)
--spsummon
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(511005712,2))
e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
e2:SetCode(EVENT_DESTROYED)
e2:SetCountLimit(1)
e2:SetCondition(c511005712.spcon)
e2:SetTarget(c511005712.sptg)
e2:SetOperation(c511005712.spop)
c:RegisterEffect(e2)
if not c511005712.global_check then
c511005712.global_check=true
--register
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EVENT_ADJUST)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e2:SetOperation(c511005712.operation)
Duel.RegisterEffect(e2,0)
end
end

function c511005712.cfilter0(c)
local val=0
if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
return c:IsFaceup() and c:IsCode(511005712) and c:GetAttack()~=val
end

function c511005712.con0(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(c511005712.cfilter0,1,nil,e:GetHandler())  and (Duel.GetCurrentPhase()>=PHASE_DRAW and Duel.GetCurrentPhase()<=PHASE_BATTLE) and  re and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:IsActiveType(TYPE_MONSTER) and not re==e:GetHandler() )
end

function c511005712.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
if chk==0 then return true end
Duel.SetTargetCard(e:GetHandler())
end

function c511005712.activate2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local ct=Duel.GetMatchingGroupCount(c511005712.cfilter0,tp,LOCATION_MZONE,0,nil)
if ct>0 then
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(1000*ct)
e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
c:RegisterEffect(e1)

if ct==0 then return end
end
end


--How to call Token properly for effect etc
function c511005712.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
Duel.CreateToken(tp,419)
Duel.CreateToken(1-tp,419)
Duel.RegisterFlagEffect(tp,419,nil,0,1)
Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
end
end


function c511005712.rcfilter555(c,tp)
return c:IsFaceup()  and c:GetAttack()>c:GetBaseAttack() and c:GetControler()==1-tp
end

--?? check into how this works-- nonetheless ...
function c511005712.condition(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetMatchingGroupCount(c511005712.rcfilter,tp,0,LOCATION_MZONE,nil)==0 then return false end
local c=e:GetHandler()
local tp=c:GetControler()
return eg:IsExists(function (c) return c:GetFlagEffect(284)>0  and c:GetFlagEffectLabel(284)~=0 and c:IsControler(1-e:GetHandlerPlayer()) end,1,e:GetHandler(),1-tp)  and  (Duel.GetCurrentPhase()>=PHASE_DRAW and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end


--Target/activate for when monster increase ATK by spell + 200 ATK
function c511005712.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(1-tp) end
if chk==0 then return true end
Duel.SetTargetCard(e:GetHandler())
end

function c511005712.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local ct=Duel.GetMatchingGroupCount(c511005712.rcfilter,tp,0,LOCATION_MZONE,nil)
if ct>0 then
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(1000*ct)
e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
c:RegisterEffect(e1)

if ct==0 then return end
end
end


function c511005712.rcfilter(c,tp)
return c:IsFaceup()  and c:GetAttack()>c:GetBaseAttack() 
end


function c511005712.rcfilter2(c)
return c:IsFaceup()  and c:GetAttack()>c:GetBaseAttack() 
end

function c511005712.rccon(e,tp,eg,ep,ev,re,r,rp)
return Duel.IsExistingMatchingCard(c511005712.rcfilter,tp,0,LOCATION_MZONE,1,nil) 
end


function c511005712.spcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousAttackOnField()>c:GetBaseAttack()
end

function c511005712.spfilter(c,e,tp)
return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c511005712.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
and Duel.IsExistingTarget(c511005712.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectTarget(tp,c511005712.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c511005712.spop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e) then
Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
end
