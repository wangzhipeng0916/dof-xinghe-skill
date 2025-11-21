// ---------------------codeStart---------------------// 

/**
 * 被動物件處理函數 - 新祭司職業技能
 * @param {Object} passiveObject - 被動物件實例
 */
function procAppend_po_qq506807329new_priest_24374(passiveObject)
{
    if (!passiveObject) return;
    
    local skillId = passiveObject.getVar("skill").get_vector(0);
    
    // 根據技能ID進行不同處理
    handleSkillProcessById(passiveObject, skillId);
}

function handleSkillProcessById(passiveObject, skillId)
{
    switch (skillId)
    {
    case 237: handleSkill237Process(passiveObject); break; // 技能237處理
    case 238: handleSkill238Process(passiveObject); break; // 技能238處理
    case 241: handleSkill241Process(passiveObject); break; // 技能241處理
    case 245: handleSkill245Process(passiveObject); break; // 技能245處理
    case 248: handleSkill248Process(passiveObject); break; // 技能248處理
    case 249: handleSkill249Process(passiveObject); break; // 技能249處理
    case 136: handleSkill136Process(passiveObject); break; // 技能136處理
    case 137: handleSkill137Process(passiveObject); break; // 技能137處理
    case 116: handleSkill116Process(passiveObject); break; // 技能116處理
    }
}

function handleSkill237Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    local state = passiveObject.getVar("state").get_vector(0);
    
    switch (subType)
    {
    case 1:
        switch (state)
        {
        case 10: // 狀態10
            if (passiveObject.sq_GetParentState() != 237)
                passiveObject.addSetStatePacket(11, null, STATE_PRIORITY_AUTO, false, "");
            break;
        case 11: // 狀態11
            if (passiveObject.getMyPassiveObjectCount(24374) <= 0)
                sq_SendDestroyPacketPassiveObject(passiveObject);
            break;
        }
        break;
        
    case 2:
        local parentCollisionObject = sq_GetCNRDObjectToCollisionObject(passiveObject.getParent());
        if (parentCollisionObject)
        {
            local state = passiveObject.getVar("state").get_vector(0);
            
            if (state == 10)
            {
                local attackObjectCount = parentCollisionObject.getVar("atkobj").get_obj_vector_size();
                for (local i = 0; i < attackObjectCount; i++)
                {
                    local attackObject = sq_GetCNRDObjectToCollisionObject(parentCollisionObject.getVar("atkobj").get_obj_vector(i));
                    if (attackObject)
                        sq_AddHitObject(passiveObject, attackObject);
                }
                
                local currentTime = sq_GetObjectTime(passiveObject);
                local totalTime = 500;
                local variableData = passiveObject.getVar();
                local posX = sq_GetUniformVelocity(variableData.get_vector(0), variableData.get_vector(2), currentTime, totalTime);
                local posY = sq_GetUniformVelocity(variableData.get_vector(1), variableData.get_vector(3), currentTime, totalTime);
                
                sq_setCurrentAxisPos(passiveObject, 0, posX);
                sq_setCurrentAxisPos(passiveObject, 1, posY);
                
                if (currentTime > 350)
                {
                    local alphaValue = sq_GetAccel(255, 0, currentTime - 350, 150, true);
                    local currentAnimation = passiveObject.getCurrentAnimation();
                    currentAnimation.setRGBA(255, 255, 255, alphaValue);
                    
                    local layerCount = sq_AniLayerListSize(currentAnimation);
                    for (local i = 0; i < layerCount; i++)
                    {
                        local layerObject = sq_getAniLayerListObject(currentAnimation, i);
                        layerObject.setRGBA(255, 255, 255, alphaValue);
                    }
                }
                
                if (passiveObject.isMyControlObject())
                    if (currentTime >= totalTime)
                        sq_SendDestroyPacketPassiveObject(passiveObject);
            }
            else if (state == 11)
            {
                if (passiveObject.isMyControlObject())
                    if (!sq_GetMoveParent(passiveObject))
                        sq_SendDestroyPacketPassiveObject(passiveObject);
            }
        }
        else if (passiveObject.isMyControlObject())
            sq_SendDestroyPacketPassiveObject(passiveObject);
        break;
    }
}

function handleSkill238Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local state = passiveObject.getVar("state").get_vector(0);
        if (state == 12)
        {
            local animationObject = passiveObject.getVar("aniobj").get_obj_vector(0);
            if (sq_IsEnd(animationObject.getCurrentAnimation()))
            {
                animationObject.setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "BlueDragon/WorkBlueDragon_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "RedPhoenix/WorkPhoenix_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "Turtle/WorkHyunmu_02.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/", "WhiteTiger/WorkWhiteTiger_02.ani"));
            }
            
            local barrierBackAnimation = passiveObject.getVar().GetAnimationMap("GatherBarrierBack_01", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Barrier/GatherBarrierBack_01.ani");
            local barrierFrontAnimation = passiveObject.getVar().GetAnimationMap("GatherBarrierFront_01", "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Barrier/GatherBarrierFront_01.ani");
            
            if (sq_IsEnd(barrierBackAnimation))
            {
                sq_Rewind(barrierBackAnimation);
                sq_Rewind(barrierFrontAnimation);
            }
            
            if (passiveObject.getVar("time").size_vector() > 0)
            {
                local elapsedTime = sq_GetObjectTime(passiveObject) - passiveObject.getVar("time").get_vector(0);
                local animationTime = 250;
                local objectCount = passiveObject.getVar().get_obj_vector_size();
                
                if (objectCount > 0)
                {
                    local targetX = passiveObject.getXPos();
                    local targetY = passiveObject.getYPos() - 1;
                    local variableData = passiveObject.getVar();
                    
                    for (local i = 0; i < objectCount; i++)
                    {
                        local activeObject = sq_GetCNRDObjectToActiveObject(variableData.get_obj_vector(i));
                        if (!activeObject.isDead())
                        {
                            local appendage = CNSquirrelAppendage.sq_GetAppendage(activeObject, "character/xinghe/priest/qumo/pentagon/ap_pentagon.nut");
                            if (appendage)
                            {
                                local moveX = sq_GetUniformVelocity(appendage.getVar().get_vector(0), targetX, elapsedTime, animationTime);
                                local moveY = sq_GetUniformVelocity(appendage.getVar().get_vector(1), targetY, elapsedTime, animationTime);
                                sq_setCurrentAxisPos(activeObject, 0, moveX);
                                sq_setCurrentAxisPos(activeObject, 1, moveY);
                            }
                        }
                    }
                }
                
                local startRate = passiveObject.getVar("rate").get_vector(0);
                local endRate = passiveObject.getVar("rate").get_vector(1);
                local currentRate = sq_GetUniformVelocity(startRate, endRate, elapsedTime, animationTime);
                passiveObject.getVar("rate").set_vector(2, currentRate);
                
                local rateFloat = currentRate.tofloat() / 1000000.0;
                barrierBackAnimation.setImageRateFromOriginal(rateFloat, rateFloat);
                barrierBackAnimation.setAutoLayerWorkAnimationAddSizeRate(rateFloat);
                barrierFrontAnimation.setImageRateFromOriginal(rateFloat, rateFloat);
                barrierFrontAnimation.setAutoLayerWorkAnimationAddSizeRate(rateFloat);
                
                if (elapsedTime >= animationTime)
                {
                    objectCount = passiveObject.getVar().get_obj_vector_size();
                    if (objectCount > 0)
                    {
                        local variableData = passiveObject.getVar();
                        for (local i = 0; i < objectCount; i++)
                        {
                            local activeObject = sq_GetCNRDObjectToActiveObject(variableData.get_obj_vector(i));
                            if (!activeObject.isDead())
                            {
                                local appendage = CNSquirrelAppendage.sq_GetAppendage(activeObject, "character/xinghe/priest/qumo/pentagon/ap_pentagon.nut");
                                if (appendage)
                                {
                                    appendage.getVar().set_vector(0, activeObject.getXPos());
                                    appendage.getVar().set_vector(1, activeObject.getYPos());
                                    appendage.getVar("isMove").setBool(0, true);
                                }
                            }
                        }
                    }
                    passiveObject.getVar("time").clear_vector();
                }
            }
        }
    }
}

function handleSkill241Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local state = passiveObject.getVar("state").get_vector(0);
        if (state < 13)
        {
            local animationObject = passiveObject.getVar("aniobj").get_obj_vector(0);
            if (animationObject && sq_IsEnd(animationObject.getCurrentAnimation()))
            {
                animationObject.setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "workbluedragon_1.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(1)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "workwhitetiger_1.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(2)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "workhyunmu_1.ani"));
                (passiveObject.getVar("aniobj").get_obj_vector(3)).setCurrentAnimation(sq_CreateAnimation("passiveobject/script_sqr_nut_qq506807329/priest/animation/advanceddragon/advanceddragon_bright/", "workphoenix_1.ani"));
            }
        }
    }
}

function handleSkill245Process(passiveObject)
{
    local parentObject = passiveObject.getParent();
    if (!parentObject)
    {
        if (passiveObject.isMyControlObject())
            sq_SendDestroyPacketPassiveObject(passiveObject);
        return;
    }
    
    local subType = passiveObject.getVar("subType").get_vector(0);
    switch (subType)
    {
    case 1:
        if (passiveObject.getVar("state").get_vector(0) == 10)
        {
            local elapsedTime = sq_GetObjectTime(passiveObject) - passiveObject.getVar().get_vector(0);
            local effectTime = 150;
            local alphaValue = sq_GetUniformVelocity(0, 250, elapsedTime, effectTime);
            local currentAnimation = passiveObject.getCurrentAnimation();
            local effectColor = sq_RGB(255, 255, 255);
            local effectAlpha = sq_ALPHA(alphaValue);
            
            currentAnimation.setEffectLayer(true, GRAPHICEFFECT_LINEARDODGE, true, effectColor, effectAlpha, true, false);
            
            local layerCount = sq_AniLayerListSize(currentAnimation);
            if (layerCount > 0)
            {
                for (local i = 0; i < layerCount; i++)
                {
                    local layerObject = sq_getAniLayerListObject(currentAnimation, i);
                    if (layerObject)
                    {
                        local currentEffect = layerObject.GetCurrentFrame().GetGraphicEffect();
                        if (currentEffect != GRAPHICEFFECT_LINEARDODGE)
                            layerObject.setEffectLayer(true, GRAPHICEFFECT_LINEARDODGE, true, effectColor, effectAlpha, true, false);
                    }
                }
            }
            
            if (passiveObject.isMyControlObject())
                if (elapsedTime >= effectTime)
                    sq_SendDestroyPacketPassiveObject(passiveObject);
        }
        break;
        
    case 2:
        local state = passiveObject.getVar("state").get_vector(0);
        if (state == 10)
        {
            local currentAnimation = passiveObject.getCurrentAnimation();
            local currentTime = sq_GetCurrentTime(currentAnimation);
            local totalTime = currentAnimation.getDelaySum(false);
            local posX = sq_GetDistancePos(passiveObject.getVar("move").get_vector(0),
                passiveObject.getDirection(),
                sq_GetUniformVelocity(0, 130, currentTime, totalTime));
            local posY = passiveObject.getVar("move").get_vector(1) + 20 * sq_SinTable(sq_GetUniformVelocity(0, 180, currentTime, totalTime));
            
            sq_setCurrentAxisPos(passiveObject, 0, posX);
            sq_setCurrentAxisPos(passiveObject, 1, posY.tointeger());
        }
        else if (state == 11)
        {
            if (passiveObject.getVar("move").size_vector() > 0)
            {
                local currentAnimation = passiveObject.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnimation) - currentAnimation.getDelaySum(0, 1);
                local animationTime = currentAnimation.getDelaySum(2, 2);
                local posX = sq_GetDistancePos(passiveObject.getVar("move").get_vector(0),
                    passiveObject.getDirection(),
                    sq_GetUniformVelocity(0, 10, currentTime, animationTime));
                
                sq_setCurrentAxisPos(passiveObject, 0, posX);
                if (currentTime >= animationTime)
                    passiveObject.getVar("move").clear_vector();
            }
        }
        break;
        
    case 4:
        if (passiveObject.getVar("move").size_vector() > 0)
        {
            local currentAnimation = passiveObject.getCurrentAnimation();
            local elapsedTime = sq_GetObjectTime(passiveObject) - passiveObject.getVar("move").get_vector(1);
            local animationTime = currentAnimation.getDelaySum(5, 10);
            local posX = sq_GetDistancePos(passiveObject.getVar("move").get_vector(0),
                passiveObject.getDirection(),
                sq_GetUniformVelocity(0, 50, elapsedTime, animationTime));
            
            sq_setCurrentAxisPos(passiveObject, 0, posX);
            if (elapsedTime >= animationTime)
                passiveObject.getVar("move").clear_vector();
        }
        break;
    }
}

function handleSkill248Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local state = passiveObject.getVar("state").get_vector(0);
        switch (state)
        {
        case 10:
            local parentObject = passiveObject.getParent();
            if (!parentObject || parentObject.getState() != 248)
            {
                if (passiveObject.isMyControlObject())
                {
                    local stateVector = sq_GetGlobalIntVector();
                    sq_IntVectorClear(stateVector);
                    sq_IntVectorPush(stateVector, passiveObject.getXPos());
                    sq_IntVectorPush(stateVector, passiveObject.getYPos());
                    passiveObject.addSetStatePacket(11, stateVector, STATE_PRIORITY_AUTO, false, "");
                }
            }
            break;
        }
    }
}

function handleSkill249Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 0)
    {
        local parentObject = passiveObject.getParent();
        if (parentObject && parentObject.isMyControlObject())
        {
            local objectManager = parentObject.getObjectManager();
            if (!objectManager) return;
            
            local fieldY = objectManager.getFieldYPos(0, 0, ENUM_DRAWLAYER_NORMAL);
            sq_setCurrentAxisPos(passiveObject, 1, fieldY);
            
            local animationObject = passiveObject.getVar("aniobj").get_obj_vector(0);
            if (animationObject)
            {
                local fieldX = objectManager.getFieldXPos(400, ENUM_DRAWLAYER_NORMAL);
                sq_setCurrentAxisPos(animationObject, 0, fieldX);
                sq_setCurrentAxisPos(animationObject, 1, fieldY);
            }
        }
    }
}

function handleSkill136Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 2)
    {
        local state = passiveObject.getVar("state").get_vector(0);
        switch (state)
        {
        case 10:
            local currentAnimation = passiveObject.getCurrentAnimation();
            local currentTime = sq_GetCurrentTime(currentAnimation);
            local totalTime = currentAnimation.getDelaySum(false);
            local zPos = sq_GetUniformVelocity(passiveObject.getVar("move").get_vector(0), passiveObject.getVar("move").get_vector(1), currentTime, totalTime);
            sq_setCurrentAxisPos(passiveObject, 2, zPos);
            break;
            
        case 11:
            local objectTime = sq_GetObjectTime(passiveObject);
            local elapsedTime = objectTime - passiveObject.getVar("move").get_vector(0);
            local totalTime = 2000;
            local zPos = sq_GetUniformVelocity(passiveObject.getVar("move").get_vector(1), 30, elapsedTime, totalTime);
            sq_setCurrentAxisPos(passiveObject, 2, zPos);
            
            if (objectTime > 3000 && passiveObject.isMyControlObject())
                passiveObject.addSetStatePacket(12, null, STATE_PRIORITY_AUTO, false, "");
            break;
        }
    }
}

function handleSkill137Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        if (passiveObject.getVar().getBool(0) == true)
        {
            if (passiveObject.getVar().get_obj_vector_size() <= 0 && passiveObject.getCurrentAnimation() == null)
            {
                local passiveObjInstance = passiveObject.getMyPassiveObject(24374, 0);
                if (passiveObjInstance && passiveObjInstance.isMyControlObject())
                    sq_SendDestroyPacketPassiveObject(passiveObjInstance);
                
                if (passiveObject.isMyControlObject())
                    sq_SendDestroyPacketPassiveObject(passiveObject);
            }
        }
    }
}

function handleSkill116Process(passiveObject)
{
    local subType = passiveObject.getVar("subType").get_vector(0);
    if (subType == 1)
    {
        local topCharacter = passiveObject.getTopCharacter();
        if (!topCharacter || topCharacter.getState() != 63)
        {
            if (passiveObject.isMyControlObject())
                sq_SendDestroyPacketPassiveObject(passiveObject);
            return;
        }
    }
}

// ---------------------codeEnd---------------------//