--Ice Pillar Mechanic
--edo9300
function c422.initial_effect(c)
    if not IcePillarZone then
        IcePillarZone={}
        IcePillarZone[1]=0
        IcePillarZone[2]=0
        --disable field
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetCondition(function()return IcePillarZone[1]|(IcePillarZone[2]<<16)>0 end)
        e1:SetValue(function()
            return IcePillarZone[1]|(IcePillarZone[2]<<16)
        end)
        Duel.RegisterEffect(e1,0)
        --negate attack
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_ATTACK_ANNOUNCE)
        e2:SetOperation(function(e,tp)
            local tc=Duel.GetAttacker()
            if CheckPillars(tp,1) and tc and tc:GetControler()~=tp and Duel.SelectYesNo(tp,aux.Stringid(4014,0)) then
                IcePillarZone[tp+1]=IcePillarZone[tp+1] & ~Duel.SelectFieldZone(tp,1,LOCATION_MZONE,LOCATION_MZONE,~IcePillarZone[tp+1])
                Duel.NegateAttack()
            end
        end)
        Duel.RegisterEffect(e2,0)
        Duel.RegisterEffect(e2:Clone(),1)
        CheckPillars=function(tp,c,zone)
            local chkzone = zone and zone&IcePillarZone[1+tp] or IcePillarZone[1+tp]
            local seq=0
            for seq=0,7 do
                if(chkzone&(1<<seq))>0 then
                    c=c-1
                end
            end
            return c<1
        end
    end
end