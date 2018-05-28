--トリガー・ヴルム (Anime)
--Triggering Wurm (Anime)
--scripted by Larry126
function c511600067.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95504778,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,95504778+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c511600067.spcon)
	e1:SetTarget(c511600067.sptg)
	e1:SetOperation(c511600067.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95504778,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c511600067.drcon)
	e2:SetTarget(c511600067.drtg)
	e2:SetOperation(c511600067.drop)
	c:RegisterEffect(e2)
end
duel.specialsum
function c511600067.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41 and re:GetHandler():IsType(TYPE_LINK)
end
function c511600067.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511600067.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c511600067.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c511600067.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=re:GetHandler():GetLinkedZone(tp)&0x1f
	if chk==0 then return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c511600067.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=re:GetHandler():GetLinkedZone(tp)&0x1f
	if c:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
	end
end