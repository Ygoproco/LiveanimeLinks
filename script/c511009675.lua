--Sunavalon Glorious Growth
function c511009675.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511009675.condition)
	e1:SetTarget(c511009675.target)
	e1:SetOperation(c511009675.activate)
	c:RegisterEffect(e1)
	
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetDescription(aux.Stringid(34408491,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_RECOVER)
	e3:SetCondition(c511009675.damcon)
	e3:SetTarget(c511009675.damtg)
	e3:SetOperation(c511009675.damop)
	c:RegisterEffect(e3)
	
	 -- Once per turn, when your opponent's monster declares a direct attack:
	 -- You can target that attacking monster; negate the attack, 
	 -- then that targeted monster can make a second attack in a row,
	 -- and must attack a "Sunvine" monster you control. 
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94804055,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c511009675.atkcon)
	e2:SetTarget(c511009675.atktg)
	e2:SetOperation(c511009675.atkop)
	c:RegisterEffect(e2)
	
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c511009675.sdescon)
	e3:SetOperation(c511009675.sdesop)
	c:RegisterEffect(e3)
end
function c511009675.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c511009675.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009676,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511009675.linkfilter(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsSetCard(0x574)
end
function c511009675.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511009676,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,511009676)
	-- Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	-- Duel.SpecialSummonComplete()
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
	and Duel.IsExistingMatchingCard(c511009675.linkfilter,tp,LOCATION_EXTRA,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(85431040,1))  then
		local g=Duel.SelectMatchingCard(tp,c511009675.filter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
		end
	end
	Duel.BreakEffect()
	Duel.Recover(tp,ev,REASON_EFFECT)	
end


function c511009675.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c511009675.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c511009675.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--------------------------------------

function c511009675.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and not e:GetHandler():IsStatus(STATUS_CHAINING)
end

function c511009675.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c511009675.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if Duel.NegateAttack() and tc then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_MUST_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
	
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e5:SetValue(c511009675.atlimit)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e6)
	
		Duel.ChainAttack()
		
	end
end

function c511009675.atlimit(e,c)
	return not c:IsSetCard(0x574) and c:IsFacedown()
end



--------------------------------------
function c511009675.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and  c:IsSetCard(0x574) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c511009675.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511009675.sfilter,1,nil)
end
function c511009675.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
