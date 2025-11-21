// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行神聖懲罰技能
 * @param {對象} character - 角色對象
 * @return {布林值} 是否成功執行技能
 */
function checkExecutableSkill_priest_divinepunishment(character)
{
    if (!character) return false;
    
    local isSkillUsed = character.sq_IsUseSkill(251);
    if (isSkillUsed)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0);
        character.sq_AddSetStatePacket(251, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查神聖懲罰技能指令是否可用
 * @param {對象} character - 角色對象
 * @return {布林值} 指令是否可用
 */
function checkCommandEnable_priest_divinepunishment(character)
{
    if (!character) return false;
    return true;
};

/**
 * 設置神聖懲罰技能狀態
 * @param {對象} character - 角色對象
 * @param {對象} state - 狀態對象
 * @param {對象} data - 數據對象
 * @param {對象} skillData - 技能數據對象
 */
function onSetState_priest_divinepunishment(character, state, data, skillData)
{
    if (!character) return;
    
    character.sq_StopMove();
    character.sq_ZStop();
    
    local subState = character.sq_GetVectorData(data, 0);
    character.setSkillSubState(subState);
    
    switch (subState)
    {
        case 0:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(219);
            else
                character.sq_SetCurrentAnimation(211);
            character.sq_PlaySound("PR_DIVINEPUNISHMENT_01");
            character.getVar().setBool(0, false);
            character.getVar().clear_vector();
            character.getVar().clear_timer_vector();
            character.getVar("aniobj").clear_obj_vector();
            character.getVar().clear_obj_vector();
            break;
            
        case 1:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(220);
            else
                character.sq_SetCurrentAnimation(212);
            break;
            
        case 2:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(221);
            else
                character.sq_SetCurrentAnimation(213);
            character.getVar().clear_vector();
            character.getVar().push_vector(1);
            character.getVar().push_vector(character.getZPos());
            character.getVar().push_vector(225);
            character.getVar().push_vector(-1);
            character.getVar().push_vector(-1);
            character.getVar().push_vector(0);
            character.getVar().push_vector(6);
            
            local skillLevel = sq_GetSkillLevel(character, 251);
            local maxDamage = character.sq_GetLevelData(251, 2, skillLevel);
            local minDamage = character.sq_GetLevelData(251, 3, skillLevel);
            
            character.getVar("info").clear_vector();
            character.getVar("info").push_vector(maxDamage);
            character.getVar("info").push_vector(minDamage);
            character.getVar("info").push_vector(((maxDamage - minDamage) / 5.0).tointeger());
            
            character.getVar().clear_timer_vector();
            character.getVar().push_timer_vector();
            local timer = character.getVar().get_timer_vector(0);
            timer.setParameter(maxDamage, character.sq_GetLevelData(251, 1, skillLevel));
            timer.resetInstant(0);
            break;
            
        case 3:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(222);
            else
                character.sq_SetCurrentAnimation(214);
            break;
            
        case 4:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(223);
            else
                character.sq_SetCurrentAnimation(215);
            sq_EffectLayerAppendage(character, sq_RGB(255, 255, 255), 80, 200, 500, 0);
            
            local zPos = character.getZPos();
            character.getVar().clear_vector();
            character.getVar().push_vector(zPos);
            character.getVar().push_vector(zPos + 55);
            break;
            
        case 5:
            if (CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
                character.sq_SetCurrentAnimation(224);
            else
                character.sq_SetCurrentAnimation(216);
            sq_setCurrentAxisPos(character, 2, 0);
            sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/divinepunishmentlight.ptl", character, 0, 0, 350, true, 50, 0, 20);
            
            if (character.sq_IsMyControlObject())
            {
                searchChrAndSendEffectPacket_priest_divinepunishment(character);
                character.sq_StartWrite();
                character.sq_WriteDword(251);
                character.sq_WriteDword(2);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(251, 251, 4, 1.0));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
            }
            break;
    }
    
    local originalDelay = character.sq_GetDelaySum();
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    local newDelay = character.sq_GetDelaySum();
    local animationRate = originalDelay.tofloat() / newDelay.tofloat() * 100.0;
    
    local xPos = character.getXPos();
    local yPos = character.getYPos();
    local zPos = character.getZPos();
    
    switch (subState)
    {
        case 2:
            CreateAniRate(character, "character/priest/effect/animation/divinepunishment/dust_03.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, zPos, false, animationRate);
            
            local bottomAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/start_bottom_direct_01.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, 0, false, animationRate);
            local normalAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/start_direct_05.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, false, animationRate);
            
            character.getVar("aniobj").push_obj_vector(bottomAni);
            character.getVar("aniobj").push_obj_vector(normalAni);
            sq_moveWithParent(character, normalAni);
            
            CreateAniRate(character, "character/priest/effect/animation/divinepunishment/start_direct_04.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, false, animationRate);
            break;
            
        case 3:
            RemoveAllAni(character);
            
            local bottomAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/loop_bottom_direct_01.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, 0, false, animationRate);
            local normalAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/loop_direct_03.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, false, animationRate);
            
            character.getVar("aniobj").push_obj_vector(bottomAni);
            character.getVar("aniobj").push_obj_vector(normalAni);
            sq_moveWithParent(character, normalAni);
            break;
            
        case 4:
            CreateAniRate(character, "character/priest/effect/animation/divinepunishment/loopendeffect_body_06.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, false, animationRate);
            RemoveAllAni(character);
            
            local bottomAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/loopend_bottom_direct_01.ani", ENUM_DRAWLAYER_BOTTOM, xPos, yPos, 0, false, animationRate);
            local normalAni = CreateAniRate(character, "character/priest/effect/animation/divinepunishment/loopend_direct_03.ani", ENUM_DRAWLAYER_NORMAL, xPos, yPos, zPos, false, animationRate);
            
            character.getVar("aniobj").push_obj_vector(bottomAni);
            character.getVar("aniobj").push_obj_vector(normalAni);
            sq_moveWithParent(character, normalAni);
            break;
    }
};

/**
 * 神聖懲罰技能控制處理
 * @param {對象} character - 角色對象
 */
function onProcCon_priest_divinepunishment(character)
{
    if (!character) return;
    
    local subState = character.getSkillSubState();
    if (subState <= 3 && character.getVar().getBool(0) == false)
    {
        sq_SetKeyxEnable(character, 1, true);
        if (sq_IsEnterCommand(character, 1))
            character.getVar().setBool(0, true);
    }
};

/**
 * 神聖懲罰技能處理
 * @param {對象} character - 角色對象
 */
function onProc_priest_divinepunishment(character)
{
    if (!character) return;
    
    local subState = character.getSkillSubState();
    local isStateChange = false;
    
    switch (subState)
    {
        case 2:
            if (character.getVar().size_vector() <= 0) return;
            
            local characterVar = character.getVar();
            local currentAnimation = character.getCurrentAnimation();
            local elapsedTime = sq_GetCurrentTime(currentAnimation) - currentAnimation.getDelaySum(characterVar.get_vector(3), characterVar.get_vector(4));
            local totalTime = currentAnimation.getDelaySum(characterVar.get_vector(5), characterVar.get_vector(6));
            
            switch (characterVar.get_vector(0))
            {
                case 1:
                    local newZPos = sq_GetAccel(characterVar.get_vector(1), characterVar.get_vector(2), elapsedTime, totalTime, false);
                    sq_setCurrentAxisPos(character, 2, newZPos);
                    
                    if (elapsedTime >= totalTime)
                    {
                        characterVar.set_vector(0, 2);
                        characterVar.set_vector(1, newZPos);
                        characterVar.set_vector(2, newZPos - 20);
                        characterVar.set_vector(3, 0);
                        characterVar.set_vector(4, 6);
                        characterVar.set_vector(5, 7);
                        characterVar.set_vector(6, 11);
                        return;
                    }
                    break;
                    
                case 2:
                    local newZPos = sq_GetUniformVelocity(characterVar.get_vector(1), characterVar.get_vector(2), elapsedTime, totalTime);
                    sq_setCurrentAxisPos(character, 2, newZPos);
                    
                    if (elapsedTime >= totalTime)
                        isStateChange = true;
                    break;
            }
            break;
            
        case 3:
            isStateChange = true;
            break;
            
        case 4:
            local currentAnimation = character.getCurrentAnimation();
            local elapsedTime = sq_GetCurrentTime(currentAnimation);
            local totalTime = currentAnimation.getDelaySum(0, 1);
            local newZPos = sq_GetUniformVelocity(character.getVar().get_vector(0), character.getVar().get_vector(1), elapsedTime, totalTime);
            sq_setCurrentAxisPos(character, 2, newZPos);
            break;
    }
    
    local timer = character.getVar().get_timer_vector(0);
    if (timer && isStateChange)
    {
        local isMyControl = character.sq_IsMyControlObject();
        
        if (character.getVar().getBool(0) == true && isMyControl)
        {
            character.sq_IntVectClear();
            character.sq_IntVectPush(4);
            character.sq_AddSetStatePacket(251, STATE_PRIORITY_USER, true);
            return;
        }
        
        if (timer.isEnd() && isMyControl)
        {
            character.sq_IntVectClear();
            character.sq_IntVectPush(4);
            character.sq_AddSetStatePacket(251, STATE_PRIORITY_USER, true);
            return;
        }
        
        if (timer.isOnEvent(sq_GetObjectTime(character)) == true)
        {
            character.getVar().clear_obj_vector();
            local characterVar = character.getVar();
            
            if (isMyControl)
            {
                local xRange = 380;
                local yRange = 120;
                local zRange = 160;
                
                local targetX = character.getXPos() + sq_getRandom(xRange / -1, xRange);
                local targetY = character.getYPos() + sq_getRandom(yRange / -1, yRange);
                
                if (sq_getRandom(0, 100) > 40)
                {
                    local objectManager = character.getObjectManager();
                    for (local i = 0; i < objectManager.getCollisionObjectNumber(); i++)
                    {
                        local collisionObject = objectManager.getCollisionObject(i);
                        if (collisionObject
                            && collisionObject.isObjectType(OBJECTTYPE_ACTIVE)
                            && character.isEnemy(collisionObject)
                            && collisionObject.isInDamagableState(character))
                        {
                            local enemyObject = sq_GetCNRDObjectToActiveObject(collisionObject);
                            if (!enemyObject.isDead())
                            {
                                if (sq_Abs(enemyObject.getXPos() - targetX) <= xRange
                                    && sq_Abs(enemyObject.getYPos() - targetY) <= yRange
                                    && enemyObject.getZPos() <= zRange)
                                {
                                    characterVar.push_obj_vector(enemyObject);
                                }
                            }
                        }
                    }
                    
                    if (characterVar.get_obj_vector_size() > 0)
                    {
                        local randomEnemy = characterVar.get_obj_vector(sq_getRandom(0, characterVar.get_obj_vector_size() - 1));
                        if (randomEnemy)
                        {
                            targetX = randomEnemy.getXPos();
                            targetY = randomEnemy.getYPos();
                        }
                    }
                }
                
                character.sq_StartWrite();
                character.sq_WriteDword(251);
                character.sq_WriteDword(1);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(251, 251, 0, 1.0));
                sq_SendCreatePassiveObjectPacketPos(character, 24374, 0, targetX, targetY, 0);
            }
            
            if (timer.getEventTerm() > character.getVar("info").get_vector(1))
                timer.setEventTerm(timer.getEventTerm() - character.getVar("info").get_vector(2));
        }
    }
};

/**
 * 神聖懲罰技能結束狀態處理
 * @param {對象} character - 角色對象
 * @param {整數} state - 狀態ID
 */
function onEndState_priest_divinepunishment(character, state)
{
    if (!character) return;
    
    if (state != 251)
    {
        character.stopSound(9402);
        RemoveAllAni(character);
    }
};

/**
 * 神聖懲罰技能關鍵幀標誌處理
 * @param {對象} character - 角色對象
 * @param {整數} flag - 標誌值
 * @return {布林值} 處理是否成功
 */
function onKeyFrameFlag_priest_divinepunishment(character, flag)
{
    if (!character) return false;
    
    local subState = character.getSkillSubState();
    
    switch (subState)
    {
        case 0:
            if (flag == 1 && character.sq_IsMyControlObject())
                sq_flashScreen(character, 0, 0, 300, 127, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            break;
            
        case 2:
            if (flag == 0)
            {
                sq_SetMyShake(character, 2, 100);
                character.sq_PlaySound("DIVINEPUNISHMENT", 9402);
                if (character.sq_IsMyControlObject())
                    sq_flashScreen(character, 50, 0, 50, 255, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            else if (flag == 1)
            {
                sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/divinepunishment_left.ptl", character, sq_GetDistancePos(0, character.getDirection(), -100), 0, 100, true, 30, 0, 15);
                sq_CreateParticle("passiveobject/script_sqr_nut_qq506807329/priest/particle/divinepunishment_right.ptl", character, sq_GetDistancePos(0, character.getDirection(), 100), 0, 100, true, 30, 0, 15);
            }
            break;
    }
    return true;
};

/**
 * 神聖懲罰技能當前動畫結束處理
 * @param {對象} character - 角色對象
 */
function onEndCurrentAni_priest_divinepunishment(character)
{
    if (!character) return;
    if (!character.sq_IsMyControlObject()) return;
    
    local subState = character.getSkillSubState();
    if (subState != 5)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(subState + 1);
        character.sq_AddSetStatePacket(251, STATE_PRIORITY_USER, true);
    }
    else
    {
        character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
    }
};

/**
 * 神聖懲罰技能效果變更處理
 * @param {對象} character - 角色對象
 * @param {對象} skill - 技能對象
 * @param {對象} data - 數據對象
 */
function onChangeSkillEffect_priest_divinepunishment(character, skill, data)
{
    if (!character) return;
    
    local effectType = data.readWord();
    switch (effectType)
    {
        case 1:
            onAppendAppendageAddEff_priest_divinepunishment(character, data);
            break;
    }
};

/**
 * 搜尋角色並發送效果封包
 * @param {對象} character - 角色對象
 */
function searchChrAndSendEffectPacket_priest_divinepunishment(character)
{
    if (!character) return;
    
    local targetList = [];
    local objectManager = character.getObjectManager();
    
    for (local i = 0; i < objectManager.getCollisionObjectNumber(); i++)
    {
        local collisionObject = objectManager.getCollisionObject(i);
        if (!collisionObject || character.isEnemy(collisionObject) || !collisionObject.isObjectType(OBJECTTYPE_CHARACTER)) continue;
        
        local targetCharacter = sq_GetCNRDObjectToSQRCharacter(collisionObject);
        if (targetCharacter && !targetCharacter.isDead())
        {
            targetList.push(sq_GetGroup(targetCharacter));
            targetList.push(sq_GetUniqueId(targetCharacter));
        }
    }
    
    local listSize = targetList.len();
    if (listSize > 0)
    {
        sq_BinaryStartWrite();
        sq_BinaryWriteWord(1);
        sq_BinaryWriteDword(listSize / 2);
        foreach (dataValue in targetList)
            sq_BinaryWriteDword(dataValue);
        sq_SendChangeSkillEffectPacket(character, 251);
    }
};

/**
 * 附加效果處理
 * @param {對象} character - 角色對象
 * @param {對象} data - 數據對象
 */
function onAppendAppendageAddEff_priest_divinepunishment(character, data)
{
    if (!character) return;
    
    local targetCount = data.readDword();
    local skillLevel = sq_GetSkillLevel(character, 251);
    local bonusValue = (targetCount / 2 * sq_GetLevelData(character, 251, 5, skillLevel)).tofloat();
    local validTime = sq_GetLevelData(character, 251, 6, skillLevel);
    
    for (local i = 0; i < targetCount; i++)
    {
        local targetCharacter = sq_GetCNRDObjectToSQRCharacter(sq_GetObject(character, data.readDword(), data.readDword()));
        if (targetCharacter && !targetCharacter.isDead())
        {
            local appendage = CNSquirrelAppendage.sq_AppendAppendage(targetCharacter, targetCharacter, 251, false, "character/xinghe/priest/divinepunishment/ap_divinepunishment.nut", false);
            appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(character), 251, skillLevel);
            CNSquirrelAppendage.sq_AppendAppendageID(appendage, targetCharacter, targetCharacter, 251, true);
            appendage.sq_SetValidTime(validTime);
            
            local statusChange = appendage.sq_getChangeStatus("changeStatus");
            if (!statusChange)
                statusChange = appendage.sq_AddChangeStatusAppendageID(targetCharacter, targetCharacter, 0, CHANGE_STATUS_TYPE_HP_MAX, false, 0, APID_COMMON);
            
            if (statusChange)
            {
                statusChange.clearParameter();
                statusChange.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_ATTACK, false, bonusValue);
                statusChange.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, bonusValue);
                statusChange.addParameter(CHANGE_STATUS_TYPE_MAGICAL_DEFENSE, false, bonusValue);
                statusChange.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_DEFENSE, false, bonusValue);
            }
        }
    }
};

// ---------------------codeEnd---------------------//