--オーバーレイ・リジェネレート
function c511001632.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001632.target)
	e1:SetOperation(c511001632.activate)
	c:RegisterEffect(e1)
end
function c511001632.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c511001632.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetMatchingGroupCount(c511001632.filter,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c511001632.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct1+ct2>0 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=ct1 
		and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>=ct2 end
end
function c511001632.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511001632.filter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c511001632.filter,tp,0,LOCATION_MZONE,nil)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
	if ct1<g1:GetCount() 
		or ct2<g2:GetCount() then return end
	if g1:GetCount()>0 then
		local og=Group.CreateGroup()
		for i=1,g1:GetCount() do
			local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,ct1-i)
			og:AddCard(tc)
		end
		while og:GetCount()>0 and g1:GetCount()>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sgo=og:Select(tp,1,1,nil)
			og:Sub(sgo)
			local sg=g1:Select(tp,1,1,nil)
			g1:Sub(sg)
			Duel.Overlay(sg:GetFirst(),sgo)
		end
	end
	if g2:GetCount()>0 then
		local og=Group.CreateGroup()
		for i=1,g2:GetCount() do
			local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,ct2-i)
			og:AddCard(tc)
		end
		while og:GetCount()>0 and g2:GetCount()>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sgo=og:Select(1-tp,1,1,nil)
			og:Sub(sgo)
			local sg=g2:Select(1-tp,1,1,nil)
			g2:Sub(sg)
			Duel.Overlay(sg:GetFirst(),sgo)
		end
	end
end
