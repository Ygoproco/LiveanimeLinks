--トリックスター・ライブステージ
--Trickstar Live Stage
--scripted by Larry126
function c511600176.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c511600176.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4709881,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,511600176)
	e2:SetTarget(c511600176.tktg1)
	e2:SetOperation(c511600176.tkop1)
	c:RegisterEffect(e2)
	--token2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63492244,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,511600177)
	e3:SetCondition(c511600176.tkcon)
	e3:SetTarget(c511600176.tktg2)
	e3:SetOperation(c511600176.tkop2)
	c:RegisterEffect(e3)
end
function c511600176.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb) and c:IsAbleToHand()
end
function c511600176.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFlagEffect(tp,511600176)>0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c511600176.thfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(35371948,0)) then
		Duel.RegisterFlagEffect(tp,511600176,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c511600176.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0xfb)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,c:GetLinkedZone()&0x1f)>0
end
function c511600176.tktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511600176.filter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c511600176.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600177,0xfb,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511600176.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c511600176.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local zones=tc:GetLinkedZone()&0x1f
	local token=Duel.CreateToken(tp,511600177)
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup()
		or not token:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zones) then return end
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zones)
end
function c511600176.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c511600176.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511600176.cfilter,tp,0,LOCATION_SZONE,1,nil)
end
function c511600176.tktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600177,0xfb,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c511600176.tkop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511600177,0xfb,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,511600177)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
