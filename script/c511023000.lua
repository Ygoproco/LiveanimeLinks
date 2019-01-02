--隻眼のスキル・ゲイナー
--One-Eyed Skill Gainer (Anime)
--fixed by MLD and senpaizuri and Larry126
function c511023000.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43387895,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c511023000.copycost)
	e1:SetTarget(c511023000.copytg)
	e1:SetOperation(c511023000.copyop)
	c:RegisterEffect(e1,false,1)
end
function c511023000.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c511023000.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER) and not c:IsType(TYPE_TOKEN) 
end
function c511023000.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c511023000.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511023000.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511023000.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c511023000.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end
