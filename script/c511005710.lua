--Starlight Force
--scripted by GameMaster(GM)
function c511005710.initial_effect(c)
--Activate/level change
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_SPSUMMON_SUCCESS)
e1:SetTarget(c511005710.tg)
e1:SetOperation(c511005710.op)
e1:SetCondition(c511005710.con)
c:RegisterEffect(e1)
--disable
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD)
e2:SetCode(EFFECT_DISABLE)
e2:SetRange(LOCATION_SZONE)
e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
e2:SetTarget(c511005710.tg2)
c:RegisterEffect(e2)
--level increase
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e3:SetRange(LOCATION_SZONE)
e3:SetCountLimit(1)
e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
e3:SetTarget(c511005710.tg3)
e3:SetOperation(c511005710.op3)
e3:SetCondition(c511005710.con3)
c:RegisterEffect(e3)
--destroy on endphase if your monsters lv sum is <= lv sum opp
local e4=Effect.CreateEffect(c)
e4:SetCategory(CATEGORY_DESTROY)
e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e4:SetCode(EVENT_PHASE+PHASE_END)
e4:SetRange(LOCATION_SZONE)
e4:SetCountLimit(1)
e4:SetCondition(c511005710.con4)
e4:SetOperation(c511005710.desop)
c:RegisterEffect(e4)
end

function c511005710.con4(e,c)
local c=e:GetHandler()
--self destruct
local g1=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
local g2=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),0,LOCATION_MZONE,nil)
if g1:GetSum(Card.GetLevel) <= g2:GetSum(Card.GetLevel) then 
return true
else 
return false 
end
end

function c511005710.desop(e,tp,eg,ep,ev,re,r,rp)
Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c511005710.tg2(e,c)
return (c:IsPreviousLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:GetFlagEffect(511005710)>0 )
end

function c511005710.cfilter(c)
return c:IsPreviousLocation(LOCATION_EXTRA)
end

function c511005710.con(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(c511005710.cfilter,1,nil,nil)
end

--synchros and fusion and monsters on the field  become level 4  v negated ^^
--------------------------------

function c511005710.filter(c)
return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
end

function c511005710.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c511005710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

function c511005710.op(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005710.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
local tc=g:GetFirst()
while tc do
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_CHANGE_LEVEL)
e1:SetValue(4)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)

tc:RegisterFlagEffect(511005710,RESET_EVENT+0x1ec0000,0,1)
tc=g:GetNext()
end
end

--------------------------------

--increase level by 1
----------------------------------

function c511005710.con3(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()==tp
end

function c511005710.filter2(c)
return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetFlagEffect(511005710)>0
end

function c511005710.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c511005710.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end

function c511005710.op3(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c511005710.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
local tc=g:GetFirst()
while tc do
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_LEVEL)
e1:SetValue(1)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
tc=g:GetNext()
end
end