--Gouki The Solid Ogre
--fixed by MLD
function c511009018.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c511009018.matfilter,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c511009018.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92204263,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c511009018.seqtg)
	e3:SetOperation(c511009018.seqop)
	c:RegisterEffect(e3)
end
function c511009018.matfilter(c)
	return c:IsLinkSetCard(0xfc)
end
function c511009018.indesfil(c)
	return c:IsFaceup() and c:IsSetCard(0xfc)
end
function c511009018.incon(e)
	return e:GetHandler():GetLinkedGroupCount()>0 
	and e:GetHandler():GetLinkedGroup():IsExists(c511009018.indesfil,1,nil)
end
function c511009018.seqfilter(c,zone)
	return c:IsFaceup() and c:IsSetCard(0xfc) and c:GetSequence()<5 
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,c:GetControler(),LOCATION_REASON_CONTROL,zone)>0
end
function c511009018.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)&0x1f
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511009018.seqfilter(chkc,zone) end
	if chk==0 then return Duel.IsExistingTarget(c511009018.seqfilter,tp,LOCATION_MZONE,0,1,nil,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(92204263,1))
	Duel.SelectTarget(tp,c511009018.seqfilter,tp,LOCATION_MZONE,0,1,1,nil,zone)
end
function c511009018.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)&0x1f
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) 
		or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE,tc:GetControler(),LOCATION_REASON_CONTROL,zone)<=0 then return end
	local i=0
	if not c:IsControler(tp) then i=16 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~(zone<<i)),2)-i
	Duel.MoveSequence(tc,nseq)
end
