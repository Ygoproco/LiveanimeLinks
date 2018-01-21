--フリッグのリンゴ
function c511003080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511003080.condition)
	e1:SetTarget(c511003080.target)
	e1:SetOperation(c511003080.activate)
	c:RegisterEffect(e1)
	if not c511003080.global_check then
		c511003080.global_check=true
		c511003080[0]=0
		c511003080[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c511003080.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511003080.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511003080.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		c511003080[tp]=c511003080[tp]+ev
	end
	if ep==1-tp then
		c511003080[1-tp]=c511003080[1-tp]+ev
	end
end
function c511003080.clear(e,tp,eg,ep,ev,re,r,rp)
	c511003080[0]=0
	c511003080[1]=0
end
function c511003080.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c511003080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,42671152,0,0x4011,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c511003080[tp])
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511003080.activate(e,tp,eg,ep,ev,re,r,rp)
	local rec=Duel.Recover(tp,c511003080[tp],REASON_EFFECT)
	if rec~=c511003080[tp] or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,42671152,0,0x4011,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,42671152)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c511003080[tp])
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	token:RegisterEffect(e2,true)
	Duel.SpecialSummonComplete()
end
