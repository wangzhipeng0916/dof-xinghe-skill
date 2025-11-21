// ---------------------codeStart---------------------//

// 附體技能效果處理 - 牧師變身狀態管理
// 作者：GCT60 QQ506807329  說明：NUT腳本引擎專用，支援1500種技能和1000種以上特效，包含NPC、NPK、動作、物件、UI等各種資源，可自由修改使用。

/**
 * 註冊附體功能函數名稱
 * @param {object} appendage - 附體物件
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("onStart", "onStart_appendage_priest_metamorphosis");
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_metamorphosis");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_metamorphosis");
}

/**
 * 附體開始處理函數
 * @param {object} appendageObj - 附體物件
 */
function onStart_appendage_priest_metamorphosis(appendageObj)
{
    if(!appendageObj) return;
    
    local parentCharacter = sq_GetCNRDObjectToSQRCharacter(appendageObj.getParent());
    if(!parentCharacter)
    {
        appendageObj.setValid(false);
        return;
    }
    
    local skillLevel = sq_GetSkillLevel(parentCharacter, 139);
    local effectDuration = parentCharacter.sq_GetLevelData(139, 7, skillLevel);
    
    appendageObj.getVar().clear_timer_vector();
    appendageObj.getVar().push_timer_vector();
    local durationTimer = appendageObj.getVar().get_timer_vector(0);
    durationTimer.setParameter(effectDuration, -1);
    durationTimer.resetInstant(50);
    
    appendageObj.getVar().setBool(0, false); // 標記是否魔力耗盡
    appendageObj.getVar().setBool(1, false); // 標記是否已發送結束封包
}

/**
 * 附體持續處理函數
 * @param {object} appendageObj - 附體物件
 */
function proc_appendage_priest_metamorphosis(appendageObj)
{
    if(!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    if(!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if(parentObj.isDead())
    {
        sendEndPacket_appendage_priest_metamorphosis(appendageObj, parentObj);
        return;
    }
    
    if(appendageObj.getVar().getBool(0) == true)
    {
        switch(parentObj.getState())
        {
            case STATE_STAND: 
            case STATE_ATTACK: 
            case STATE_DASH:
                sendEndPacket_appendage_priest_metamorphosis(appendageObj, parentObj);
                return;
        }
    }
    
    parentObj.setCustomOutline(true, sq_RGBA(255, 0, 0, 20), false, 4);
    
    local currentAnimation = parentObj.getCurrentAnimation();
    if(currentAnimation)
    {
        local effectColor = sq_RGB(0, 0, 0);
        local effectAlpha = sq_ALPHA(220);
        currentAnimation.setEffectLayer(true, GRAPHICEFFECT_NONE, true, effectColor, effectAlpha, true, false);
        
        local layerCount = sq_AniLayerListSize(currentAnimation);
        local baseFrameCount = sq_GetAniFrameNumber(currentAnimation, 0);
        local baseDelaySum = currentAnimation.getDelaySum(false);
        
        for(local layerIndex = 0; layerIndex < layerCount; layerIndex++)
        {
            local layerObject = sq_getAniLayerListObject(currentAnimation, layerIndex);
            if(layerObject 
                && sq_GetAniFrameNumber(layerObject, 0) == baseFrameCount 
                && layerObject.getDelaySum(false) == baseDelaySum)
            {
                local currentEffect = layerObject.GetCurrentFrame().GetGraphicEffect();
                if(currentEffect != GRAPHICEFFECT_LINEARDODGE)
                    layerObject.setEffectLayer(true, GRAPHICEFFECT_NONE, true, effectColor, effectAlpha, true, false);
            }
        }
    }
    
    parentObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
    if(!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if(parentObj.isCarryWeapon())
        parentObj.setCarryWeapon(false);
    
    local durationTimer = appendageObj.getVar().get_timer_vector(0);
    if(durationTimer)
    {
        if(durationTimer.isOnEvent(appendageObj.getTimer().Get()) == true)
        {
            local currentSkillLevel = sq_GetSkillLevel(parentObj, 139);
            consumeDevilGauge(parentObj, parentObj.sq_GetLevelData(139, 8, currentSkillLevel));
            
            local currentEffectDuration = parentObj.sq_GetLevelData(139, 7, currentSkillLevel);
            if(durationTimer.getEventTerm() != currentEffectDuration)
                durationTimer.setEventTerm(currentEffectDuration);
            
            if(getDevilGauge(parentObj) <= 0 && appendageObj.getVar().getBool(0) == false)
                appendageObj.getVar().setBool(0, true);
        }
    }
}

/**
 * 附體結束處理函數
 * @param {object} appendageObj - 附體物件
 */
function onEnd_appendage_priest_metamorphosis(appendageObj)
{
    if(!appendageObj) return;
    
    local parentCharacter = sq_GetCNRDObjectToSQRCharacter(appendageObj.getParent());
    if(!parentCharacter)
    {
        appendageObj.setValid(false);
        return;
    }
    
    if(parentCharacter.getState() != 67)
    {
        sq_EffectLayerAppendageOnlyBody(parentCharacter, sq_RGB(0, 0, 0), 200, 0, 0, 200);
        
        local endAnimation = sq_CreateAnimation("", "character/priest/effect/animation/metamorphosis/end/end_normal.ani");
        local endEffect = sq_CreatePooledObject(endAnimation, true);
        sq_SetCurrentDirection(endEffect, sq_GetDirection(parentCharacter));
        endEffect = sq_SetEnumDrawLayer(endEffect, ENUM_DRAWLAYER_NORMAL);
        endEffect.setCurrentPos(sq_GetXPos(parentCharacter), sq_GetYPos(parentCharacter), sq_GetZPos(parentCharacter));
        sq_AddObject(parentCharacter, endEffect, OBJECTTYPE_DRAWONLY, false);
        
        if(parentCharacter.sq_IsMyControlObject())
            sq_flashScreen(parentCharacter, 0, 100, 100, 102, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
    }
    
    parentCharacter.setCustomOutline(false, sq_RGBA(255, 0, 0, 10), false, 4);
    
    if(!parentCharacter.isCarryWeapon())
        parentCharacter.setCarryWeapon(true);
}

/**
 * 發送附體結束封包函數
 * @param {object} appendageObj - 附體物件
 * @param {object} parentCharacter - 父角色物件
 */
function sendEndPacket_appendage_priest_metamorphosis(appendageObj, parentCharacter)
{
    if(!appendageObj || !parentCharacter) return;
    
    if(appendageObj.getVar().getBool(1) == false)
    {
        appendageObj.getVar().setBool(1, true);
        if(parentCharacter.isMyControlObject())
        {
            sq_BinaryStartWrite();
            sq_BinaryWriteWord(2);
            sq_SendChangeSkillEffectPacket(parentCharacter, 139);
        }
    }
}

// ---------------------codeEnd---------------------//