--イリュージョン・バルーン (Anime)
--Illusion Balloons (Anime)
--scripted by Larry126
function c511600118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c511600118.condition)
	e1:SetTarget(c511600118.target)
	e1:SetOperation(c511600118.operation)
	c:RegisterEffect(e1)
	if not c511600118.global_check then
		c511600118.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c511600118.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511600118.checkop(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		if ec:IsPreviousLocation(LOCATION_MZONE) then
			if ec:GetPreviousControler()==0 then 
				Duel.RegisterFlagEffect(0,511600118,RESET_PHASE+PHASE_END,0,1)
			else 
				Duel.RegisterFlagEffect(1,511600118,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function c511600118.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,511600118)>0
end
function c511600118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=Duel.GetFlagEffect(tp,511600118) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c511600118.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local ct=Duel.GetFlagEffect(tp,511600118)
	Duel.ConfirmDecktop(tp,ct)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,ct):Filter(Card.IsSetCard,nil,0x9f)
	local mg,lv=g:GetMaxGroup(Card.GetLevel)
	local tg=mg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ShuffleDeck(tp)
end