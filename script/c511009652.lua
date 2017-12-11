-- Dark mummy Copper Forceps
function c511009652.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x56f),3,3)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511009652.atkval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(114932,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetCost(c511009652.drcost)
	e2:SetTarget(c511009652.drtg)
	e2:SetOperation(c511009652.drop)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(122520,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c511009652.spcost)
	e3:SetCondition(c511009652.spcon)
	e3:SetTarget(c511009652.sptg)
	e3:SetOperation(c511009652.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_MSET)
	c:RegisterEffect(e5)
end
function c511009652.atkval(e,c)
	return c:GetLinkedGroupCount()*600
end


function c511009652.filter(c)
	return c:IsType(TYPE_TRAP) and not c:IsPublic()
end
function c511009652.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c511009652.filter,1,nil) end
	local g=eg:Filter(c511009652.filter,nil)
	if g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
end
function c511009652.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c511009652.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end




function c511009652.cfilter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsControler(tp) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c511009652.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c511009652.spcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c511009652.lkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone()
	end
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c511009652.cfilter,1,nil,tp,zone)
end
function c511009652.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c511009652.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local zone=0
	local lg=Duel.GetMatchingGroup(c511009652.lkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone()
	end
	if chk==0 then return eg:IsExists(c511009652.cfilter,1,nil,tp,zone) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c511009652.spop(e,tp,eg,ep,ev,re,r,rp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local zone=0
	local lg=Duel.GetMatchingGroup(c511009652.lkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone()
	end
	local g=eg:Filter(c511009652.filter,nil,e,tp,zone) 
	Duel.Destroy(g,REASON_EFFECT)
end

