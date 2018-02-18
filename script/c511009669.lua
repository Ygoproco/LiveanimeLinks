--Sunvine Thrasher
function c511009669.initial_effect(c)
	
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511009669.matfilter,1,1)

	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511009669.descon)
	c:RegisterEffect(e1)
	-- If this card is Special Summoned: Target 1 "Sunavalon" Link Monster that points to this card; this card gains ATK equal to that monster's Link Rating x 800. 
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3954901,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c511009669.atktg)
	e2:SetOperation(c511009669.atkop)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96622984,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetTarget(c511009669.destg)
	e2:SetOperation(c511009669.atkop)
	c:RegisterEffect(e2)
end
function c511009669.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_NORMAL,lc,sumtype,tp) and c:IsRace(RACE_PLANT,lc,sumtype,tp)
end

function c511009669.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK)
end
function c511009669.descon(e)
	return not Duel.IsExistingMatchingCard(c511009669.filter,0,LOCATION_MZONE,0,1,nil)
end

--------------------------------------------------------




function c511009669.filter(c,card)
	return c:IsFaceup() and c:IsSetCard(0x574) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(card)
end
function c511009669.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c511009669.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511009669.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
end
function c511009669.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetLink()*800)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end


--------------------------------------------------------
function c511009669.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() end
	
end
function c511009669.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_DESTROYED)
		e3:SetCondition(c511009669.sumcon)
		e3:SetOperation(c511009669.sumop)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_DESTROY)
		e4:SetLabelObject(e3)
		e4:SetOperation(c511009669.checkop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e4)
	
end

function c511009669.checkop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	e3:SetLabel(1)
end
function c511009669.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end

function c511009669.lkfilter(c)
	return c:IsSetCard(0x574) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009669.zonefilter(tp)
	local lg=Duel.GetMatchingGroup(c511009669.lkfilter,tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone()>>16
	end
	return zone
end

function c511009669.sumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local zone=c511009669.zonefilter(tp)
	if zone~=0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	
	
	e:SetLabel(0)
	e:Reset()
end
