--Revolve Boot Sector
--リボルブート・セクター
--scripted by Larry126
function c511600027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x201))
	e2:SetValue(300)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(168917,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,511600027)
	e4:SetTarget(c511600027.sptg)
	e4:SetOperation(c511600027.spop)
	c:RegisterEffect(e4)
	--evacuate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10753491,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,511600027)
	e5:SetTarget(c511600027.mttg)
	e5:SetOperation(c511600027.mtop)
	c:RegisterEffect(e5)
end
function c511600027.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,6) end
end
function c511600027.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,6) then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6)
	if g:GetCount()>0 then
		local tg=g:Filter(Card.IsSetCard,nil,0x201)
		if tg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REVEAL)
		end
		local ac=6-tg:GetCount()
		Duel.SortDecktop(tp,tp,ac)
		for i=1,ac do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end
function c511600027.spfilter(c,e,tp)
	return c:IsSetCard(0x201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511600027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511600027.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c511600027.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c511600027.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g=Group.CreateGroup()
	::start::
		local cancel=g:GetCount()>0
		local cg=mg
		if g:GetCount()>0 then
			cg=mg:Filter(aux.NOT(Card.IsCode),nil,g:GetFirst():GetCode())
		end
		local tc=Group.SelectUnselect(cg,g,tp,cancel,cancel,1,2)
		if not tc then goto jump end
		if not g:IsContains(tc) then
			g:AddCard(tc)
		else
			g:RemoveCard(tc)
		end
		if ft==1 then goto jump end
		goto start
	::jump::
	if g:GetCount()==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end