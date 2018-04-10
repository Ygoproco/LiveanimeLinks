--Maha Viho (DOR)
--Scripted by GameMaster(GM) + André
function c511005858.initial_effect(c)
--+200 atk when card gains atk via spell card
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
e1:SetCode(511001441)
e1:SetCondition(c511005858.condition)
e1:SetTarget(c511005858.target)
e1:SetOperation(c511005858.activate)
e1:SetRange(LOCATION_MZONE)
c:RegisterEffect(e1)
--+200 def when card gains def via spell card
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
e2:SetCode(511009565)
e2:SetCondition(c511005858.condition)
e2:SetTarget(c511005858.target2)
e2:SetOperation(c511005858.activate2)
e2:SetRange(LOCATION_MZONE)
c:RegisterEffect(e2)
if not c511005858.global_check then
c511005858.global_check=true
--register
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EVENT_ADJUST)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e2:SetOperation(c511005858.operation)
Duel.RegisterEffect(e2,0)
end
end


--How to call Token properly for effect etc
function c511005858.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
Duel.CreateToken(tp,419)
Duel.CreateToken(1-tp,419)
Duel.RegisterFlagEffect(tp,419,nil,0,1)
Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
end
end


function c511005858.condition(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsDefensePos() and eg:IsExists(function (c) return c:GetFlagEffect(284)>0 and c:GetFlagEffectLabel(284)~=0 end,1,nil) and re and re:GetHandler():GetType()==TYPE_SPELL 
end


--Target/activate for when monster increase ATK by spell + 200 ATK
function c511005858.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
if chk==0 then return true end
Duel.SetTargetCard(eg)
end

function c511005858.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
local g=tg:Filter(Card.IsRelateToEffect,nil,e,tp)
if g:GetCount()>0 then
local tc=g:GetFirst()
while tc do
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(200)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
tc=g:GetNext()
end
end
end


--Target/activate for when monster increase DEF  by spell + 200 DEF 
function c511005858.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
if chk==0 then return true end
Duel.SetTargetCard(eg)
end

function c511005858.activate2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
local g=tg:Filter(Card.IsRelateToEffect,nil,e,tp)
if g:GetCount()>0 then
local tc=g:GetFirst()
while tc do
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_DEFENSE)
e1:SetValue(200)
e1:SetReset(RESET_EVENT+0x1fe0000)
tc:RegisterEffect(e1)
tc=g:GetNext()
end
end
end