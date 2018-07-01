--次元领域决斗
--Dimension Duel
--scripted by Larry126
--note: Please contact with me if wanting to edit this script
function c511600002.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(0xff)
	e1:SetOperation(c511600002.op)
	c:RegisterEffect(e1)
end
function c511600002.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--check if number of card >20 if speed duel or >40 if other duel
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,0xff,0xff,1,nil,511004001)
		and Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND+LOCATION_DECK,0,c)<20 then
		return Duel.Win(1-tp,0x60)
	elseif Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND+LOCATION_DECK,0,c)<40 
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,0xff,0xff,1,nil,511004001) then
		return Duel.Win(1-tp,0x60)
	end
	if Duel.GetFlagEffect(tp,511600002)==0 and Duel.GetFlagEffect(1-tp,511600002)==0 then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,511600002,0,0,0)
	--limit summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCondition(c511600002.limitcon)
		e1:SetOperation(c511600002.limitop)
		Duel.RegisterEffect(e1,tp)
	--Damage
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DESTROYED)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTarget(c511600002.damcon)
		e2:SetOperation(c511600002.damop)
		Duel.RegisterEffect(e2,tp)
	--no battle damage
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetTargetRange(1,1)
		e3:SetCondition(c511600002.bcon)
		Duel.RegisterEffect(e3,tp)
	--Dimension Summon
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(4010,0))
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SUMMON_PROC)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
		e4:SetTarget(function(e,c)return c:GetFlagEffect(51160002)==0 end)
		e4:SetCondition(c511600002.ntcon)
		e4:SetValue(6)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetTarget(function(e,c)return c:GetFlagEffect(51160002)>0 end)
		e5:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e5:SetValue(6)
		Duel.RegisterEffect(e5,tp)
	--spirit
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_SUMMON_SUCCESS)
		e6:SetTarget(c511600002.spttg)
		e6:SetOperation(c511600002.sptop)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(e7,tp)
		local e8=e6:Clone()
		e8:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e8,tp)
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	if c:IsPreviousLocation(LOCATION_HAND) then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c511600002.limitfilter(c)
	return c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC) and c:GetFlagEffect(51160002)<=0
end
function c511600002.limitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511600002.limitfilter,tp,0xff,0xff,1,nil)
end
function c511600002.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c511600002.limitfilter,tp,0xff,0xff,nil)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(51160002,0,0,0)
		end
	end
end
------------------------------------------------------------------------
--tribute
function c511600002.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
------------------------------------------------------------------------
function c511600002.sptfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_TRAPMONSTER+TYPE_TOKEN) and c:IsOnField()
end
function c511600002.spttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511600002.sptfilter,1,nil) end
end
function c511600002.sptop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511600002.sptfilter,nil)
	for tc in aux.Next(g) do
		local baseAtk=0
		local baseDef=0
		local textAtk=tc:GetTextAttack()
		local textDef=tc:GetTextDefense()
		local ctl=tc:GetControler()
		if textAtk~=-2 and textAtk~=0 then
			Duel.Hint(HINT_SELECTMSG,ctl,aux.Stringid(4010,4))
			local atkop=Duel.SelectOption(ctl,aux.Stringid(4010,1),aux.Stringid(4010,2),aux.Stringid(4010,3))
			if atkop==0 then
				baseAtk=textAtk
			elseif atkop==1 then
				baseAtk=0
			elseif atkop==2 then
				baseAtk=aux.ComposeNumberDigitByDigit(ctl,0,textAtk)
			end
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(baseAtk)
			e1:SetReset(RESET_EVENT+0xec0000)
			tc:RegisterEffect(e1)
		end
		if textDef~=-2 and textDef~=0 then
			Duel.Hint(HINT_SELECTMSG,ctl,aux.Stringid(4010,5))
			local defop=Duel.SelectOption(ctl,aux.Stringid(4010,1),aux.Stringid(4010,2),aux.Stringid(4010,3))
			if defop==0 then
				baseDef=textDef
			elseif defop==1 then
				baseDef=0
			elseif defop==2 then
				baseDef=aux.ComposeNumberDigitByDigit(ctl,0,textDef)
			end
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(baseDef)
			e2:SetReset(RESET_EVENT+0xec0000)
			tc:RegisterEffect(e2)
		end
	end
end
------------------------------------------------------------------------
--inflict battle damage
function c511600002.damfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_TRAPMONSTER+TYPE_TOKEN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c511600002.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511600002.damfilter,1,nil)
end
function c511600002.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511600002.damfilter,nil)
	local dam1=0
	local dam2=0
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	while tc do 
		local def=tc:GetPreviousDefenseOnField()
		local atk=tc:GetPreviousAttackOnField()
		local ctl=tc:GetControler()
		if tc:IsPreviousPosition(POS_ATTACK) then
			Duel.Damage(ctl,atk,REASON_RULE,true)
		elseif tc:IsPreviousPosition(POS_DEFENSE) then
			Duel.Damage(ctl,def,REASON_RULE,true)
		end
		tc=g:GetNext()
	end
	Duel.RDComplete()
end
------------------------------------------------------------------------
--no battle damaged
function c511600002.bcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end