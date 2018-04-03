--Arsenal Bug(DOR)
--scripted by GameMaster(GM)
function c511005794.initial_effect(c)
--+1500 if control another insect monster
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_ATKCHANGE)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
e1:SetOperation(c511005794.operation)
e1:SetCondition(c511005794.con)
c:RegisterEffect(e1)
--field as forest- activates when this card attacks
local e2=Effect.CreateEffect(c)
e2:SetCategory(CATEGORY_ATKCHANGE)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_F)
e2:SetCode(EVENT_BATTLE_CONFIRM)
e2:SetOperation(c511005794.op2)
c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_FIELD)
e3:SetCode(EFFECT_UPDATE_ATTACK)
e3:SetRange(LOCATION_MZONE)
e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT+RACE_BEAST+RACE_PLANT+RACE_BEASTWARRIOR))
e3:SetCondition(c511005794.sdcon)
e3:SetValue(500)
c:RegisterEffect(e3)
local e4=e3:Clone()
e4:SetCode(EFFECT_UPDATE_DEFENSE)
c:RegisterEffect(e4)
end

function c511005794.sdcon(e)
return  Duel.IsEnvironment(87430998)
end

function c511005794.filter2(c)
return c and c:IsCode(code) and c:IsFaceUp()
end

function c511005794.con2(e)
return
not c511005794.filter2(Duel.GetFieldCard(0,LOCATION_SZONE,5)) and
not c511005794.filter2(Duel.GetFieldCard(1,LOCATION_SZONE,5))
end

function c511005794.atktg(e,c)
return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT+RACE_PLANT+RACE_BEASTWARRIOR)
end

function c511005794.op2(e)
local c=e:GetHandler()
--field
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_FIELD)
e3:SetCondition(c511005794.con2)
e3:SetRange(LOCATION_MZONE)
e3:SetCode(EFFECT_CHANGE_ENVIRONMENT)
e3:SetValue(87430998)
c:RegisterEffect(e3)
end

function c511005794.con(e,tp,eg,ep,ev,re,r,rp)
return Duel.IsExistingMatchingCard(c511005794.filter,tp,LOCATION_MZONE,0,1,nil) 
end

function c511005794.filter(c,code)
return c:IsRace(RACE_INSECT)  and c:GetCode()~=42364374
end

function c511005794.operation(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetValue(1500)
e1:SetReset(RESET_EVENT+0x00800000)
e:GetHandler():RegisterEffect(e1)
local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
e:GetHandler():RegisterEffect(e2)
end