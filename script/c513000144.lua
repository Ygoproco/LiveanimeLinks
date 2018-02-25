--Golden Castle of Stromberg
--rewrote by edo9300
function c513000144.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--mantain cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c513000144.millcon)
	e2:SetOperation(c513000144.millop)
	c:RegisterEffect(e2)
	--special summon Lv <=4 from deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c513000144.sumtg)
	e3:SetOperation(c513000144.sumop)
	c:RegisterEffect(e3)
	--Cannot Normal Summon Monsters
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--Cannot Normal Summon Monsters
	local e4a=e4:Clone()
	e4a:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4a)
	--Opponents monsters must attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e5)
	--Destroy monsters
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(c513000144.atkcon)
	e6:SetTarget(c513000144.atktg)
	e6:SetOperation(c513000144.atkop)
	c:RegisterEffect(e6)
	--indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(c513000144.indval)
	c:RegisterEffect(e7)
end
function c513000144.millcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c513000144.millop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	if not Duel.IsPlayerCanDiscardDeckAsCost(1-tp,#g//2) or #g//2==0 then
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
	local gc=g:RandomSelect(1-tp,#g//2)
	Duel.SendtoGrave(gc,REASON_COST)
end
function c513000144.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c513000144.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c513000144.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c513000144.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c513000144.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
function c513000144.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker() and Duel.GetAttacker():GetControler()~=tp
end
function c513000144.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetAttacker():IsOnField() and Duel.GetAttacker():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c513000144.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
	end
end
