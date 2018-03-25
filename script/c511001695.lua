--Cardian - Matsu
function c511001695.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001695,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511001695.spcost)
	e1:SetTarget(c511001695.sptg)
	e1:SetOperation(c511001695.spop)
	c:RegisterEffect(e1,false,2)
	aux.CallToken(419)
end
function c511001695.filter(c,ft,tp)
	local re=c:GetReasonEffect()
	return (ft>0 or c:GetSequence()<5) and c:GetLevel()==1 and c:IsSetCard(0xe6)
		and (not c:IsSummonType(SUMMON_TYPE_SPECIAL) or (not re or not re:GetHandler():IsSetCard(0xe6) or not re:GetHandler():IsType(TYPE_MONSTER)))
end
function c511001695.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,c511001695.filter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c511001695.filter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c511001695.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511001695.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			if c419.cardianchk(tc,tp,eg,ep,ev,re,r,rp) then
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
