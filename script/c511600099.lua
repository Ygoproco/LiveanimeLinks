--クラスター・コンジェスター (Anime)
--Cluster Congester (Anime)
--scripted by Larry126
--fixed by MLD
function c511600099.initial_effect(c)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetLabelObject(g)
	e0:SetRange(0x7e)
	e0:SetCondition(c511600099.descon)
	e0:SetTarget(c511600099.destg)
	e0:SetOperation(c511600099.desop)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(e0)
	e1:SetCountLimit(1,511600099)
	e1:SetCondition(c511600099.tkcon1)
	e1:SetTarget(c511600099.tktg1)
	e1:SetOperation(c511600099.tkop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--tokens
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e3:SetLabelObject(e0)
	e3:SetCondition(c511600099.tkcon2)
	e3:SetCost(c511600099.tkcost2)
	e3:SetTarget(c511600099.tktg2)
	e3:SetOperation(c511600099.tkop2)
	c:RegisterEffect(e3)
end
function c511600099.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c511600099.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject():Filter(Card.IsOnField,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*300)
	end
end
function c511600099.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsOnField,nil)
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end
function c511600099.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511600099.tkcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c511600099.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511600099.tktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600099+100,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c511600099.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600099+100,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then
		local tk=Duel.CreateToken(tp,511600199)
		Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
		e:GetLabelObject():GetLabelObject():AddCard(tk)
	end
end
function c511600099.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceup() and at:IsType(TYPE_LINK)
end
function c511600099.tkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.GetAttackTarget():IsAbleToRemoveAsCost() end
	local g=Group.FromCards(e:GetHandler(),Duel.GetAttackTarget())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c511600099.tktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,Duel.GetAttackTarget())>0 
		and Duel.IsExistingMatchingCard(c511600099.filter,tp,0,LOCATION_MZONE,1,Duel.GetAttackTarget())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c511600099.tkop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,94703022,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	local ct=math.min(Duel.GetMatchingGroupCount(c511600099.filter,tp,0,LOCATION_MZONE,nil),Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	repeat
		local token=Duel.CreateToken(tp,94703022)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		e:GetLabelObject():GetLabelObject():AddCard(token)
		ct=ct-1
	until ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(94703021,0))
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
