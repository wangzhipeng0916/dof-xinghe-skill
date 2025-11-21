function onAttack_po_qq506807329new_priest_24374(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    if(!passiveObject) return 0;
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillAttackById(passiveObject, targetObject, attackInfo, isSkillAttack, skillId);
    return 0;
}

function handleSkillAttackById(passiveObject, targetObject, attackInfo, isSkillAttack, skillId)
{
    switch(skillId)
    {
        case 237: handleSkill237Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 毀滅神像相關技能
        case 238: handleSkill238Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 聖潔五角星相關技能
        case 241: handleSkill241Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 龍之怒相關技能
        case 243: handleSkill243Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 爆裂拳相關技能
        case 248: handleSkill248Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 神聖庇護所相關技能
        case 246: handleSkill246Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 洗禮相關技能
        case 136: handleSkill136Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 黑暗嚎叫相關技能
        case 137: handleSkill137Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 毀滅壓制相關技能
        case 132: handleSkill132Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 惡魔邀請相關技能
        case 116: handleSkill116Attack(passiveObject, targetObject, attackInfo, isSkillAttack); break; // 刺猬防禦相關技能
    }
}

function handleSkill237Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 2 && passiveObject.getVar("state").get_vector(0) == 10)
    {
        if(targetObject.isObjectType(OBJECTTYPE_ACTIVE))
        {
            local parentCollisionObject = sq_GetCNRDObjectToCollisionObject(passiveObject.getParent()); 
            if(parentCollisionObject && !parentCollisionObject.getVar("atkobj").is_obj_vector(targetObject)) 
            {
                parentCollisionObject.getVar("atkobj").push_obj_vector(targetObject); 
                if(passiveObject.isMyControlObject())
                {
                    local globalVector = sq_GetGlobalIntVector(); 
                    sq_IntVectorClear(globalVector); 
                    sq_IntVectorPush(globalVector, sq_GetGroup(targetObject)); 
                    sq_IntVectorPush(globalVector, sq_GetUniqueId(targetObject)); 
                    passiveObject.addSetStatePacket(11, globalVector, STATE_PRIORITY_AUTO, false, ""); 
                }
            }
        }
    }
}

function handleSkill238Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    if(!isSkillAttack 
        && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
    {
        local hitAnimation = sq_CreateAnimation("", "character/priest/effect/animation/pentagon/hiteffect_02.ani"); 
        local hitEffectObject = sq_CreatePooledObject(hitAnimation, true); 
        sq_SetCurrentDirection(hitEffectObject, passiveObject.getDirection()); 
        hitEffectObject.setCurrentPos(targetObject.getXPos(), targetObject.getYPos(), targetObject.getZPos() + sq_GetCenterZPos(attackInfo)); 
        hitEffectObject = sq_SetEnumDrawLayer(hitEffectObject, ENUM_DRAWLAYER_NORMAL); 
        sq_AddObject(passiveObject, hitEffectObject, OBJECTTYPE_DRAWONLY, false); 
    }
}

function handleSkill241Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 2)
    {
        if(!isSkillAttack 
            && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
        {
            local scaleRate = sq_GetObjectHeight(targetObject) / 150.0; 
            CreateAniRate(passiveObject, "character/priest/effect/animation/advanceddragon_passion/hit/hit_hitdodge.ani", ENUM_DRAWLAYER_NORMAL, targetObject.getXPos(), targetObject.getYPos() + 1, targetObject.getZPos() + sq_GetCenterZPos(attackInfo), scaleRate, false); 
        }
    }
}

function handleSkill243Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    if(!isSkillAttack 
        && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
    {
        if(targetObject.isMyControlObject())
        {
            local globalVector = sq_GetGlobalIntVector(); 
            sq_IntVectorClear(globalVector); 
            sq_IntVectorPush(globalVector, sq_GetOppositeDirection(passiveObject.getDirection())); 
            sq_IntVectorPush(globalVector, 0); 
            sq_IntVectorPush(globalVector, 1); 
            sq_IntVectorPush(globalVector, 250); 
            sq_IntVectorPush(globalVector, 500); 
            sq_AddSetStatePacketCollisionObject(targetObject, STATE_DOWN, globalVector, STATE_PRIORITY_FORCE, true);
        }
    }
}

function handleSkill248Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        if(!isSkillAttack 
            && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
        {
            local effectPath = "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/hit/attack_d_back.ani";
            if(passiveObject.getVar("state").get_vector(0) == 13)
                effectPath = "passiveobject/script_sqr_nut_qq506807329/priest/animation/hollysanctuary/hit/heal_d2.ani";
            local hitEffectObject = sq_CreateDrawOnlyObject(passiveObject, effectPath, ENUM_DRAWLAYER_NORMAL, true); 
            hitEffectObject.setCurrentPos(targetObject.getXPos(), targetObject.getYPos(), targetObject.getZPos() + sq_GetCenterZPos(attackInfo)); 
            sq_moveWithParent(targetObject, hitEffectObject); 
        }
    }
}

function handleSkill246Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 3)
    {
        if(!isSkillAttack 
            && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
        {
            if(CNSquirrelAppendage.sq_IsAppendAppendage(passiveObject, "character/xinghe/priest/haptism/ap_haptism.nut"))
                CNSquirrelAppendage.sq_RemoveAppendage(passiveObject, "character/xinghe/priest/haptism/ap_haptism.nut");
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(targetObject, passiveObject, 246, true, "character/xinghe/priest/haptism/ap_haptism.nut", true);
            local validTime = 250; 
            appendage.sq_SetValidTime(validTime); 
            sq_MoveToAppendage(targetObject, passiveObject, passiveObject, 0, 0, targetObject.getZPos(), validTime, true, appendage); 
        }
    }
}

function handleSkill136Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
        case 3:
            if(!isSkillAttack 
                && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
            {
                local parentObject = passiveObject.getParent(); 
                if(!parentObject)return;
                local appendage = CNSquirrelAppendage.sq_GetAppendage(targetObject, "character/xinghe/priest/darkhowling/ap_darkhowling.nut"); 
                if(appendage) 
                {
                    local sourceObject = appendage.getSource(); 
                    if(!sourceObject)return; 
                    if(isSameObject(parentObject, sourceObject))return; 
                    CNSquirrelAppendage.sq_RemoveAppendage(targetObject, "character/xinghe/priest/darkhowling/ap_darkhowling.nut"); 
                }
                
                appendage = CNSquirrelAppendage.sq_AppendAppendage(targetObject, parentObject, 136, true, "character/xinghe/priest/darkhowling/ap_darkhowling.nut", true);
                if(appendage)
                {
                    appendage.getVar("endTime").clear_vector(); 
                    appendage.getVar("endTime").push_vector(passiveObject.getVar().get_vector(0)); 
                }
            }
            break;
        case 2: 
            local parentCharacter = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
            if(parentCharacter && isInDevilStrikeSkill(parentCharacter))
            {
                addDevilGauge(parentCharacter, passiveObject.getVar().get_vector(0)); 
                local hitEffectObject = sq_CreateDrawOnlyObject(passiveObject, "character/priest/effect/animation/darkhowling/buff_dodge.ani", ENUM_DRAWLAYER_NORMAL, true); 
                hitEffectObject.setCurrentPos(parentCharacter.getXPos(), parentCharacter.getYPos(), parentCharacter.getZPos() + sq_GetObjectHeight(parentCharacter) / 2); 
                sq_moveWithParent(parentCharacter, hitEffectObject); 
            }
            if(passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(12, null, STATE_PRIORITY_AUTO, false, ""); 
            break;
    }
}

function handleSkill137Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
        if(!isSkillAttack 
            && targetObject.isObjectType(OBJECTTYPE_ACTIVE) 
            && !passiveObject.getVar().is_obj_vector(targetObject)) 
        {
            passiveObject.getVar().push_obj_vector(targetObject); 
            
            if(CNSquirrelAppendage.sq_IsAppendAppendage(targetObject, "character/xinghe/priest/doomcrush/ap_doomcrush_atk.nut"))
                CNSquirrelAppendage.sq_RemoveAppendage(targetObject, "character/xinghe/priest/doomcrush/ap_doomcrush_atk.nut");
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(targetObject, passiveObject, 137, false, "character/xinghe/priest/doomcrush/ap_doomcrush_atk.nut", true);
            if(passiveObject.getVar().getBool(0) == false)
            {
                passiveObject.getVar().setBool(0, true); 
                passiveObject.setTimeEvent(0, 220, 0, false); 
            }
        }
}

function handleSkill132Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
        case 2:
            if(!isSkillAttack 
                && targetObject.isObjectType(OBJECTTYPE_ACTIVE) 
                && !CNSquirrelAppendage.sq_IsAppendAppendage(targetObject, "character/xinghe/priest/inviteofdevil/ap_inviteofdevil.nut")) 
            {
                local moveTime = 200; 
                local appendage = CNSquirrelAppendage.sq_AppendAppendage(targetObject, passiveObject, 132, false, "character/xinghe/priest/inviteofdevil/ap_inviteofdevil.nut", true);
                if(subType == 1)
                    sq_MoveToAppendage(targetObject, passiveObject, passiveObject, 135, -5, 0, moveTime, true, appendage); 
                else if(subType == 2)
                    sq_MoveToAppendage(targetObject, passiveObject, passiveObject, 135, 5, 0, moveTime, true, appendage); 
                appendage.sq_SetValidTime(moveTime); 
            }
            break;
    }
}

function handleSkill116Attack(passiveObject, targetObject, attackInfo, isSkillAttack)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        if(!isSkillAttack 
            && targetObject.isObjectType(OBJECTTYPE_ACTIVE)) 
        {
            local hitEffectObject = sq_CreateDrawOnlyObject(passiveObject, "character/priest/animation/avengerawakening/devilhedgehog/monster_shot2_back.ani", ENUM_DRAWLAYER_NORMAL, true); 
            hitEffectObject.setCurrentPos(targetObject.getXPos(), targetObject.getYPos(), targetObject.getZPos() + sq_GetCenterZPos(attackInfo)); 
        }
    }
}

function onKeyFrameFlag_po_qq506807329new_priest_24374(passiveObject, keyFrameFlag)
{
    if(!passiveObject) return false;
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillKeyFrameById(passiveObject, keyFrameFlag, skillId);
    return true;
}

function handleSkillKeyFrameById(passiveObject, keyFrameFlag, skillId)
{
    switch(skillId)
    {
        case 238: handleSkill238KeyFrame(passiveObject, keyFrameFlag); break; // 聖潔五角星相關技能
        case 241: handleSkill241KeyFrame(passiveObject, keyFrameFlag); break; // 龍之怒相關技能
        case 245: handleSkill245KeyFrame(passiveObject, keyFrameFlag); break; // 天譴之怒相關技能
        case 248: handleSkill248KeyFrame(passiveObject, keyFrameFlag); break; // 神聖庇護所相關技能
        case 249: handleSkill249KeyFrame(passiveObject, keyFrameFlag); break; // 命運之矛相關技能
        case 250: handleSkill250KeyFrame(passiveObject, keyFrameFlag); break; // 木星錘相關技能
        case 246: handleSkill246KeyFrame(passiveObject, keyFrameFlag); break; // 洗禮相關技能
        case 135: handleSkill135KeyFrame(passiveObject, keyFrameFlag); break; // 惡魔之拳相關技能
        case 132: handleSkill132KeyFrame(passiveObject, keyFrameFlag); break; // 惡魔邀請相關技能
    }
}

function handleSkill238KeyFrame(passiveObject, keyFrameFlag)
{
    if(keyFrameFlag == 1)
    {
        passiveObject.getVar("end").setBool(0, true); 
        local attackInfo = sq_GetCustomAttackInfo(passiveObject, 3); 
        sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(4)); 
        sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
        
        sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/pentagonglassbrockenleft.ptl", passiveObject, 0, 0, 180, true, 10, 0, 8);
        sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/pentagonglassbrockenright.ptl", passiveObject, 0, 0, 180, true, 10, 0, 8);
        passiveObject.sq_PlaySound("PENTAGON_BARRIER_EXP");
    }
}

function handleSkill241KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        local state = passiveObject.getVar("state").get_vector(0); 
        switch(state)
        {
            case 11:
                if(keyFrameFlag == 1)
                    sq_SetMyShake(passiveObject, 10, 500); 
                else if(keyFrameFlag == 2)
                    sq_SetMyShake(passiveObject, 5, 1000); 
                else if(keyFrameFlag == 3 && passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 100, 100, 200, 204, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                else if(keyFrameFlag == 4)
                {
                    if(passiveObject.isMyControlObject())
                    {
                        local flashObject = sq_flashScreen(passiveObject, 250, 99990, 0, 150, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                        passiveObject.getVar("flashobj").clear_obj_vector(); 
                        passiveObject.getVar("flashobj").push_obj_vector(flashObject); 
                    }
                    local backgroundAniObject = passiveObject.getVar("aniobj_new").get_obj_vector(0); 
                    sq_ChangeDrawLayer(backgroundAniObject, ENUM_DRAWLAYER_BOTTOM); 
                }
                break;
            case 12:
                if(keyFrameFlag == 1)
                    sq_SetMyShake(passiveObject, 2, 400); 
                break;
            case 14:
                if(keyFrameFlag == 1)
                {
                    sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/advanceddragonmagicrock.ptl", passiveObject, 0, 0, 50, true, 20, 0, 13); 
                    sq_SetMyShake(passiveObject, 5, 300); 
                    sq_SetMyShake(passiveObject, 20, 500); 
                    if(passiveObject.isMyControlObject())
                        sq_flashScreen(passiveObject, 0, 100, 0, 102, sq_RGB(211, 211, 211), GRAPHICEFFECT_LINEARDODGE, ENUM_DRAWLAYER_BOTTOM); 
                }
                break;
        }
    }
    else if(subType == 2)
    {
        switch(keyFrameFlag)
        {
            case 1:
                sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_passion/ground_bottom_attack_end_crack_normal.ani", ENUM_DRAWLAYER_BOTTOM, true); 
                sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_passion/attack_attack3.ani", ENUM_DRAWLAYER_BOTTOM, true); 
                break;
            case 2:
                sq_SetMyShake(passiveObject, 5, (passiveObject.getVar().getFloat(0) * 1700).tointeger()); 
                break;
            case 3:
                local scaleRate = passiveObject.getVar().getFloat(0); 
                sq_SetMyShake(passiveObject, 20, (450.0 * scaleRate * 0.5).tointeger()); 
                if(passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 100, 0, 30, 178, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                break;
            case 4:
                local scaleRate = passiveObject.getVar().getFloat(0); 
                sq_SetMyShake(passiveObject, 20, (700.0 * scaleRate / 100.0 * 0.5).tointeger()); 
                if(passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 100, 100, 30, 178, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                break;
            case 5:
                sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/advanceddragondestroyaxe.ptl", passiveObject, sq_GetDistancePos(0, passiveObject.getDirection(), -300), 0, 15, true, 10, 0, 8); 
                break;
            case 6:
                if(passiveObject.isMyControlObject())
                {
                    local flashObject = sq_flashScreen(passiveObject, 200, 99990, 0, 150, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                    passiveObject.getVar("flashobj").clear_obj_vector(); 
                    passiveObject.getVar("flashobj").push_obj_vector(flashObject); 
                }
                break;
            case 7:
                RemoveAllFlash(passiveObject); 
                if(passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 0, 0, 1000, 150, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                break;
        }
    }
}

function handleSkill245KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 1:
            if(keyFrameFlag == 1)
            {
                passiveObject.resetHitObjectList(); 
                local parentCharacter = sq_GetCNRDObjectToSQRCharacter(passiveObject.getParent()); 
                if(parentCharacter)
                {
                    local skillCount = parentCharacter.getVar().get_vector(1); 
                    if(skillCount > 0)
                        parentCharacter.getVar().set_vector(1, skillCount - 1); 
                    else if(passiveObject.isMyControlObject())
                        passiveObject.addSetStatePacket(10, null, STATE_PRIORITY_AUTO, false, ""); 
                }
            }
            break;
        case 2:
            if(passiveObject.getVar("state").get_vector(0) == 11 && keyFrameFlag == 1)
            {
                passiveObject.getVar("move").clear_vector(); 
                passiveObject.getVar("move").push_vector(passiveObject.getXPos()); 
            }
            break;
        case 4:
            if(keyFrameFlag == 1)
            {
                passiveObject.getVar("move").clear_vector(); 
                passiveObject.getVar("move").push_vector(passiveObject.getXPos()); 
                passiveObject.getVar("move").push_vector(sq_GetObjectTime(passiveObject)); 
            }
            break;
    }
}

function handleSkill248KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 1)
    {
        local state = passiveObject.getVar("state").get_vector(0); 
        if(state == 12)
        {
            if(keyFrameFlag == 0)
            {
                sq_SetMyShake(passiveObject, 3, 300); 
                if(passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 0, 80, 160, 76, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
                local xPos = passiveObject.getXPos(); 
                local yPos = passiveObject.getYPos(); 
                local healRate = (passiveObject.getVar().get_vector(0)).tofloat(); 
                local objectManager = passiveObject.getObjectManager(); 
                for(local i = 0; i < objectManager.getCollisionObjectNumber(); i++)
                {
                    local collisionObject = objectManager.getCollisionObject(i); 
                    
                    if(collisionObject && !passiveObject.isEnemy(collisionObject) && collisionObject.isObjectType(OBJECTTYPE_CHARACTER)
                        && sq_Abs(xPos - sq_GetXPos(collisionObject)) <= 225 
                        && sq_Abs(yPos - sq_GetYPos(collisionObject)) <= 70) 
                    {
                        local character = sq_GetCNRDObjectToSQRCharacter(collisionObject); 
                        if(character && !character.isDead() && character.isMyControlObject()) 
                        {
                            local currentHp = character.getHp(); 
                            local maxHp = character.getHpMax(); 
                            if(currentHp != maxHp) 
                                character.sq_SendSetHpPacket((currentHp + maxHp / 100.0 * healRate).tointeger(), true, passiveObject); 
                        }
                    }
                }
            }
        }
        else if(state == 13)
        {
            if(keyFrameFlag == 0)
            {
                sq_SetMyShake(passiveObject, 5, 500); 
                if(passiveObject.isMyControlObject())
                    sq_flashScreen(passiveObject, 0, 80, 240, 127, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_CLOSEBACK); 
            }
        }
    }
}

function handleSkill249KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    switch(subType)
    {
        case 0:
            if(keyFrameFlag == 1 && passiveObject.isMyControlObject())
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteDword(249); 
                sq_BinaryWriteDword(1); 
                sq_BinaryWriteDword(passiveObject.getVar().get_vector(0)); 
                sq_BinaryWriteDword(passiveObject.getVar().get_vector(1)); 
                sq_BinaryWriteDword(passiveObject.getVar().get_vector(2)); 
                sq_SendCreatePassiveObjectPacketPos(passiveObject, 24374, 0, passiveObject.getXPos(), passiveObject.getVar().get_vector(3), 0);
            }
            break;
        case 1:
            switch(keyFrameFlag)
            {
                case 1:
                    if(passiveObject.isMyControlObject())
                    {
                        sq_BinaryStartWrite();
                        sq_BinaryWriteDword(249); 
                        sq_BinaryWriteDword(2); 
                        sq_BinaryWriteDword(passiveObject.getVar().get_vector(0)); 
                        sq_SendCreatePassiveObjectPacket(passiveObject, 24374, 0, 0, 0, 0, passiveObject.getDirection());
                    }
                    break;
                case 2:
                    if(passiveObject.isMyControlObject())
                    {
                        sq_BinaryStartWrite();
                        sq_BinaryWriteDword(249); 
                        sq_BinaryWriteDword(3); 
                        sq_BinaryWriteDword(passiveObject.getVar().get_vector(1)); 
                        sq_SendCreatePassiveObjectPacket(passiveObject, 24374, 0, 0, -150, 0, passiveObject.getDirection());
                    }
                    sq_CreateDrawOnlyObject(passiveObject, "passiveobject/script_sqr_nut_qq506807329/priest/animation/spearofdestiny/spearofdestiny_explosion_front_eff02.ani", ENUM_DRAWLAYER_NORMAL, true); 
                    break;
            }
            break;
        case 3:
            switch(keyFrameFlag)
            {
                case 1:
                    sq_SetMyShake(passiveObject, 4, 120); 
                    break;
                case 2:
                    sq_SetMyShake(passiveObject, 10, 120); 
                    break;
                case 3:
                    passiveObject.resetHitObjectList(); 
                    break;
                case 4:
                    passiveObject.resetHitObjectList(); 
                    sq_SetMyShake(passiveObject, 2, 240); 
                    break;
            }
            break;
    }
}

function handleSkill250KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 3)
    {
        if(keyFrameFlag == 0)
        {
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 19); 
            sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(0)); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
            passiveObject.resetHitObjectList(); 
        }
    }
}

function handleSkill246KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 2)
    {
        if(keyFrameFlag == 1)
        {
            sq_SetMyShake(passiveObject, 3, 160); 
            if(passiveObject.isMyControlObject())
            {
                sq_flashScreen(passiveObject, 0, 80, 80, 25, sq_RGB(255, 255, 255), GRAPHICEFFECT_LINEARDODGE, ENUM_DRAWLAYER_COVER); 
                sq_flashScreen(passiveObject, 0, 160, 320, 127, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_CLOSEBACK); 
            }
        }
    }
}

function handleSkill135KeyFrame(passiveObject, keyFrameFlag)
{
    if(keyFrameFlag == 1)
        sq_SetMyShake(passiveObject, 7, 320); 
}

function handleSkill132KeyFrame(passiveObject, keyFrameFlag)
{
    local subType = passiveObject.getVar("subType").get_vector(0); 
    if(subType == 2)
    {
        if(passiveObject.getVar("state").get_vector(0) == 11 && keyFrameFlag == 0 && passiveObject.isMyControlObject())
        {
            sq_BinaryStartWrite();
            sq_BinaryWriteDword(132); 
            sq_BinaryWriteDword(3); 
            sq_BinaryWriteDword(passiveObject.getVar().get_vector(1)); 
            sq_SendCreatePassiveObjectPacket(passiveObject, 24374, 0, 135, 0, 30, passiveObject.getDirection());
        }
    }
    else if(subType == 3)
        if(keyFrameFlag == 1)
            sq_SetMyShake(passiveObject, 10, 200); 
}

function onTimeEvent_po_qq506807329new_priest_24374(passiveObject, eventId, eventParam)
{
    if(!passiveObject) return false;
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillTimeEventById(passiveObject, eventId, eventParam, skillId);
    return false;
}

function handleSkillTimeEventById(passiveObject, eventId, eventParam, skillId)
{
    switch(skillId)
    {
        case 137: handleSkill137TimeEvent(passiveObject, eventId, eventParam); break; // 毀滅壓制相關技能
        case 237: handleSkill237TimeEvent(passiveObject, eventId, eventParam); break; // 毀滅神像相關技能
        case 238: handleSkill238TimeEvent(passiveObject, eventId, eventParam); break; // 聖潔五角星相關技能
        case 241: handleSkill241TimeEvent(passiveObject, eventId, eventParam); break; // 龍之怒相關技能
        case 136: handleSkill136TimeEvent(passiveObject, eventId, eventParam); break; // 黑暗嚎叫相關技能
        case 132: handleSkill132TimeEvent(passiveObject, eventId, eventParam); break; // 惡魔邀請相關技能
    }
}

function handleSkill137TimeEvent(passiveObject, eventId, eventParam)
{
    switch(eventId)
    {
        case 0: 
            local relatedPassiveObject = passiveObject.getMyPassiveObject(24374, 0); 
            if(relatedPassiveObject)
            {
                local objectCount = passiveObject.getVar().get_obj_vector_size(); 
                local varContainer = passiveObject.getVar(); 
                for(local i = 0; i < objectCount; i++)
                {
                    local activeObject = sq_GetCNRDObjectToActiveObject(varContainer.get_obj_vector(i)); 
                    if(activeObject && !activeObject.isDead() && relatedPassiveObject.isMyControlObject()) 
                        sq_SendHitObjectPacket(relatedPassiveObject, activeObject, 0, 0, sq_GetObjectHeight(activeObject) / 2); 
                }
            }
            local maxEventCount = passiveObject.getVar().get_vector(0); 
            if(eventParam >= maxEventCount) 
            {
                if(relatedPassiveObject && relatedPassiveObject.isMyControlObject())
                    sq_SendDestroyPacketPassiveObject(relatedPassiveObject); 
                if(passiveObject.isMyControlObject())
                    sq_SendDestroyPacketPassiveObject(passiveObject); 
                return true;
            }
            break;
    }
}

function handleSkill237TimeEvent(passiveObject, eventId, eventParam)
{
    switch(eventId)
    {
        case 0:
            if(!passiveObject.isMyControlObject())return false;
            local randomOffset = sq_getRandom(-35, 35); 
            local distance = 500; 
            local verticalOffset = sq_getRandom(-80, 80); 
            sq_BinaryStartWrite();
            sq_BinaryWriteDword(237); 
            sq_BinaryWriteDword(2); 
            sq_BinaryWriteDword(distance);
            sq_BinaryWriteDword(verticalOffset);
            sq_BinaryWriteDword(passiveObject.getVar().get_vector(0)); 
            sq_BinaryWriteDword(passiveObject.getVar().get_vector(1)); 
            sq_BinaryWriteDword(passiveObject.getVar().get_vector(2)); 
            sq_SendCreatePassiveObjectPacket(passiveObject, 24374, 0, 0, 0, randomOffset, passiveObject.getDirection());
            break;
        case 1:
            if(passiveObject.isMyControlObject())
                sq_SendDestroyPacketPassiveObject(passiveObject); 
            break;
        case 2:
            if(!passiveObject.isMyControlObject())return false;
            sq_BinaryStartWrite();
            sq_BinaryWriteDword(237); 
            sq_BinaryWriteDword(3); 
            sq_BinaryWriteDword(passiveObject.getVar().get_vector(6)); 
            sq_SendCreatePassiveObjectPacketPos(passiveObject.getParent(), 24374, 0, passiveObject.getXPos(), passiveObject.getYPos(), passiveObject.getZPos(), passiveObject.getDirection());
            break;
    }
}

function handleSkill238TimeEvent(passiveObject, eventId, eventParam)
{
    if(eventId == 0)
    {
        if(passiveObject.isMyControlObject())
            passiveObject.addSetStatePacket(13, null, STATE_PRIORITY_AUTO, false, ""); 
    }
    else if(eventId == 1)
    {
        if(passiveObject.getVar().getBool(0) == false) 
        {
            passiveObject.getVar().setBool(0, true); 
            local attackInfo = sq_GetCustomAttackInfo(passiveObject, 2); 
            sq_SetCurrentAttackBonusRate(attackInfo, passiveObject.getVar().get_vector(3)); 
            sq_SetCurrentAttackInfo(passiveObject, attackInfo); 
        }
        passiveObject.resetHitObjectList(); 
    }
}

function handleSkill241TimeEvent(passiveObject, eventId, eventParam)
{
    if(eventId == 0)
    {
        if(passiveObject.isMyControlObject())
            passiveObject.addSetStatePacket(13, null, STATE_PRIORITY_AUTO, false, ""); 
    }
    else if(eventId == 1)
        passiveObject.resetHitObjectList(); 
}

function handleSkill136TimeEvent(passiveObject, eventId, eventParam)
{
    if(eventId == 0)
        passiveObject.resetHitObjectList(); 
    else if(eventId == 1)
    {
        local parentObject = passiveObject.getParent(); 
        if(parentObject)
        {
            local xPos = passiveObject.getXPos(); 
            local yPos = passiveObject.getYPos(); 
            local parentX = parentObject.getXPos(); 
            local parentY = parentObject.getYPos(); 
            if(xPos > parentX) sq_setCurrentAxisPos(passiveObject, 0, xPos -= 1); 
            else sq_setCurrentAxisPos(passiveObject, 0, xPos += 1); 
            if(yPos > parentY) sq_setCurrentAxisPos(passiveObject, 1, yPos -= 1); 
            else sq_setCurrentAxisPos(passiveObject, 1, yPos += 1); 
        }
        else if(passiveObject.isMyControlObject()) 
            passiveObject.addSetStatePacket(12, null, STATE_PRIORITY_AUTO, false, ""); 
    }
}

function handleSkill132TimeEvent(passiveObject, eventId, eventParam)
{
    if(eventId == 0 && passiveObject.isMyControlObject())
        passiveObject.addSetStatePacket(passiveObject.getVar("state").get_vector(0) + 1, null, STATE_PRIORITY_AUTO, false, ""); 
}

function getCustomHitEffectFileName_po_qq506807329new_priest_24374(passiveObject, attackType)
{
    if(!passiveObject) return "";
    local skillId = passiveObject.getVar("skill").get_vector(0);
    // 未實現具體功能
}

function onChangeSkillEffect_po_qq506807329new_priest_24374(passiveObject, skillId, effectParam)
{
    if(!passiveObject) return;
    switch(skillId)
    {
        case 238: 
            local currentAnimation = passiveObject.getCurrentAnimation(); 
            if(currentAnimation) sq_Rewind(currentAnimation); 
            break;
    }
}

function destroy_po_qq506807329new_priest_24374(passiveObject)
{
    if(!passiveObject) return;
    local skillId = passiveObject.getVar("skill").get_vector(0);
    switch(skillId)
    {
        case 238: 
        case 241: 
            RemoveAllAni(passiveObject); 
            break;
    }
}