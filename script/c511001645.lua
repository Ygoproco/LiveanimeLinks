--E・HERO ゴッド・ネオス (Anime)
--Elemental HERO Divine Neos (Anime)
--fixed by Larry126
function c511001645.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,89943723,c511001645.ffilter,6,6,false,true)
	aux.AddContactFusion(c,c511001645.contactfil,c511001645.contactop,c511001645.splimit)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31111109,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c511001645.copytg)
	e1:SetOperation(c511001645.copyop)
	c:RegisterEffect(e1)
end
c511001645.listed_names={89943723}
function c511001645.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
end
function c511001645.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c511001645.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x1f) and (not sg or not sg:IsExists(c511001645.fusfilter,1,c,c:GetFusionCode()))
end
function c511001645.fusfilter(c,code)
	return c:IsFusionCode(code) and not c:IsHasEffect(511002961)
end
function c511001645.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c511001645.copyfilter(c)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER)
		and not c:IsForbidden() and c:IsAbleToRemove()
end
function c511001645.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001645.copyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,500)
end
function c511001645.copyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511001645.copyfilter,tp,LOCATION_DECK,0,1,Duel.GetMatchingGroupCount(c511001645.copyfilter,tp,LOCATION_DECK,0,nil),nil)
	local c=e:GetHandler()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetOperatedGroup()
		for tc in aux.Next(g) do
			local code=tc:GetOriginalCode()
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(31111109,1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetLabel(cid)
			e1:SetOperation(c511001645.rstop)
			c:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(#g*500)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e2)
	end
end
function c511001645.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end