// ---------------------codeStart---------------------// 

/**
 * 檢查是否可執行技能「末日衝擊」
 * @param {SQRCharacter} characterObject - 角色物件
 * @return {boolean} 是否可執行技能
 */
function checkExecutableSkill_priest_doomcrush(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return false;

    local isSkillUsed = characterObject.sq_IsUseSkill(137);
    if (isSkillUsed)
    {
        characterObject.sq_IntVectClear();
        if (isAvengerAwakenning(characterObject))
            characterObject.sq_IntVectPush(1);
        else
            characterObject.sq_IntVectPush(0);
        characterObject.sq_AddSetStatePacket(137, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查技能指令是否可用
 * @param {SQRCharacter} characterObject - 角色物件
 * @return {boolean} 技能指令是否可用
 */
function checkCommandEnable_priest_doomcrush(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return false;

    local currentState = characterObject.sq_GetState();
    if (currentState == STATE_STAND)
        return true;
    if (currentState == STATE_ATTACK)
    {
        return characterObject.sq_IsCommandEnable(137);
    }
    return true;
}

/**
 * 設定技能狀態
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {number} state - 狀態
 * @param {table} dataArray - 資料陣列
 * @param {table} customData - 自訂資料
 */
function onSetState_priest_doomcrush(characterObject, state, dataArray, customData)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return;

    characterObject.sq_StopMove();
    local subState = characterObject.sq_GetVectorData(dataArray, 0);
    characterObject.setSkillSubState(subState);

    switch (subState)
    {
        case 0:
        case 1:
            characterObject.getVar("move").clear_vector();
            characterObject.getVar().setBool(0, false);
            characterObject.getVar().setBool(1, false);
            break;
    }

    switch (subState)
    {
        case 0:
            characterObject.sq_SetCurrentAnimation(231);
            characterObject.sq_SetCurrentAttackInfo(123);
            characterObject.sq_SetCurrentAttackBonusRate(characterObject.sq_GetBonusRateWithPassive(137, 137, 0, 1.0));
            characterObject.sq_PlaySound("PR_DOOMCRUSH_01");
            characterObject.getVar().setBool(2, false);
            break;
        case 1:
            local animation = characterObject.getVar().GetAnimationMap("priest_avenger_doomcrush_dash(devil)_body", "character/priest/animation/avengerawakening/doomcrush_dash(devil)_body.ani");
            characterObject.setCurrentAnimation(animation);
            characterObject.sq_SetCurrentAttackInfo(123);
            local bonusRate = characterObject.sq_GetLevelData(137, 6, sq_GetSkillLevel(characterObject, 137)) / 100.0;
            characterObject.sq_SetCurrentAttackBonusRate(characterObject.sq_GetBonusRateWithPassive(137, 137, 0, 1.0 + bonusRate));
            characterObject.sq_PlaySound("PR_DGUARDIAN_DOOMCRUSH_01");
            characterObject.getVar().setBool(2, true);
            break;
        case 2:
            local endType = characterObject.sq_GetVectorData(dataArray, 1);
            local attackCount = characterObject.sq_GetVectorData(dataArray, 2);
            local gaugeConsume = characterObject.sq_GetVectorData(dataArray, 3);
            if (gaugeConsume > 0)
                consumeDevilGauge(characterObject, gaugeConsume);
            characterObject.getVar().clear_vector();
            characterObject.getVar().push_vector(attackCount);
            if (endType == 0)
            {
                local animation = characterObject.getVar().GetAnimationMap("priest_avenger_doomcrush_end_body_body", "character/priest/animation/avengerawakening/doomcrush_end_body_body.ani");
                characterObject.setCurrentAnimation(animation);
                sq_AddDrawOnlyAniFromParent(characterObject, "character/priest/effect/animation/doomcrush/doomcrush_end_body_a00.ani", 0, 1, 0);
            }
            else if (endType == 1)
            {
                local animation = characterObject.getVar().GetAnimationMap("priest_avenger_doomcrush_end_body_charge_body", "character/priest/animation/avengerawakening/doomcrush_end_body_charge_body.ani");
                characterObject.setCurrentAnimation(animation);
                sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/doomcrush_end_body_charge_a01.ani", ENUM_DRAWLAYER_NORMAL, true);
                sq_AddDrawOnlyAniFromParent(characterObject, "character/priest/effect/animation/doomcrush/doomcrush_end_body_charge_a00.ani", 0, 1, 0);
            }
            break;
        case 3:
            characterObject.sq_SetCurrentAnimation(232);
            break;
    }

    switch (subState)
    {
        case 0:
        case 1:
            sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/readydash_dust.ani", ENUM_DRAWLAYER_NORMAL, true);
            break;
    }

    characterObject.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

/**
 * 技能持續處理（控制相關）
 * @param {SQRCharacter} characterObject - 角色物件
 */
function onProcCon_priest_doomcrush(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            if (characterObject.getVar().getBool(0) == false)
            {
                characterObject.setSkillCommandEnable(137, true);
                if (characterObject.sq_IsEnterSkill(137) != -1)
                    characterObject.getVar().setBool(0, true);
            }
            break;
    }
}

/**
 * 技能持續處理（邏輯相關）
 * @param {SQRCharacter} characterObject - 角色物件
 */
function onProc_priest_doomcrush(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            if (characterObject.getVar("move").size_vector() <= 0) return;
            local moveVar = characterObject.getVar("move");
            local currentAnim = characterObject.getCurrentAnimation();
            local elapsedTime = sq_GetCurrentTime(currentAnim) - currentAnim.getDelaySum(moveVar.get_vector(2), moveVar.get_vector(3));
            local totalTime = currentAnim.getDelaySum(moveVar.get_vector(4), moveVar.get_vector(5));
            local startPos = moveVar.get_vector(0);
            if (startPos != 0)
            {
                local newXPos = sq_GetDistancePos(startPos, characterObject.getDirection(), sq_GetAccel(0, moveVar.get_vector(1), elapsedTime, totalTime, true));
                if (characterObject.isMovablePos(newXPos, characterObject.getYPos()))
                    sq_setCurrentAxisPos(characterObject, 0, newXPos);
                else
                    moveVar.set_vector(0, 0);
            }
            local ySpeed = moveVar.get_vector(7);
            if (ySpeed != 0)
            {
                local newYPos = moveVar.get_vector(6) + sq_GetAccel(0, ySpeed, elapsedTime, totalTime, true);
                if (characterObject.isMovablePos(characterObject.getXPos(), newYPos))
                    sq_setCurrentAxisPos(characterObject, 1, newYPos);
                else
                    moveVar.set_vector(7, 0);
            }
            break;
    }
}

/**
 * 攻擊命中處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {Object} targetObject - 目標物件
 * @param {number} attackInfoIndex - 攻擊資訊索引
 * @param {boolean} isNotActive - 是否非主動攻擊
 */
function onAttack_priest_doomcrush(characterObject, targetObject, attackInfoIndex, isNotActive)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return;
    if (isNotActive || !targetObject.isObjectType(OBJECTTYPE_ACTIVE)) return;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            if (sq_IsGrabable(characterObject, targetObject)
                && sq_IsHoldable(characterObject, targetObject)
                && !sq_IsFixture(targetObject))
            {
                if (CNSquirrelAppendage.sq_IsAppendAppendage(targetObject, "character/xinghe/priest/doomcrush/ap_doomcrush.nut"))
                    CNSquirrelAppendage.sq_RemoveAppendage(targetObject, "character/xinghe/priest/doomcrush/ap_doomcrush.nut");
                local appendage = CNSquirrelAppendage.sq_AppendAppendage(targetObject, characterObject, 137, false, "character/xinghe/priest/doomcrush/ap_doomcrush.nut", true);
                sq_HoldAndDelayDie(targetObject, characterObject, true, true, true, 0, 450, ENUM_DIRECTION_NEUTRAL, appendage);
            }
            if (characterObject.getVar().getBool(1) == false)
            {
                sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/poke_dash.ani", ENUM_DRAWLAYER_NORMAL, true);
                characterObject.getVar().setBool(1, true);
            }
            break;
    }
}

/**
 * 技能效果變化處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {number} dataType - 資料類型
 * @param {table} dataPacket - 資料封包
 */
function onChangeSkillEffect_priest_doomcrush(characterObject, dataType, dataPacket)
{
    if (!characterObject) return;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            local effectType = dataPacket.readWord();
            switch (effectType)
            {
                case 1:
                    local yOffset = dataPacket.readDword();
                    local effectObject = null;
                    if (yOffset < 0)
                        effectObject = sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/eye_line_up.ani", ENUM_DRAWLAYER_NORMAL, true);
                    else if (yOffset > 0)
                        effectObject = sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/eye_line_down.ani", ENUM_DRAWLAYER_NORMAL, true);
                    else
                        effectObject = sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/eye_line_middle.ani", ENUM_DRAWLAYER_NORMAL, true);
                    sq_moveWithParent(characterObject, effectObject);
                    characterObject.getVar("move").clear_vector();
                    local moveVar = characterObject.getVar("move");
                    moveVar.push_vector(characterObject.getXPos());
                    moveVar.push_vector(150);
                    moveVar.push_vector(0);
                    moveVar.push_vector(1);
                    moveVar.push_vector(2);
                    moveVar.push_vector(10);
                    moveVar.push_vector(characterObject.getYPos());
                    moveVar.push_vector(yOffset);
                    break;
            }
            break;
    }
}

/**
 * 關鍵幀標誌處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {number} flagValue - 標誌值
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_doomcrush(characterObject, flagValue)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return false;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            switch (flagValue)
            {
                case 1:
                    sq_SetMyShake(characterObject, 5, 50);
                    if (characterObject.sq_IsMyControlObject())
                        sq_flashScreen(characterObject, 0, 160, 0, 102, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                    sq_AddDrawOnlyAniFromParent(characterObject, "character/priest/effect/animation/doomcrush/destdash_smoke.ani", 0, -1, 0);
                    break;
                case 2:
                    if (characterObject.sq_IsMyControlObject())
                    {
                        local yDirection = 0;
                        if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_UP, ENUM_SUBKEY_TYPE_ALL))
                            yDirection = -45;
                        else if (sq_IsKeyDown(OPTION_HOTKEY_MOVE_DOWN, ENUM_SUBKEY_TYPE_ALL))
                            yDirection = 45;
                        sq_BinaryStartWrite();
                        sq_BinaryWriteWord(1);
                        sq_BinaryWriteDword(yDirection);
                        sq_SendChangeSkillEffectPacket(characterObject, 137);
                    }
                    break;
            }
            break;
        case 2:
            if (flagValue == 1)
            {
                if (characterObject.sq_IsMyControlObject())
                {
                    local bonusRate = characterObject.sq_GetLevelData(137, 6, sq_GetSkillLevel(characterObject, 137)) / 100.0;
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(137);
                    characterObject.sq_WriteDword(1);
                    if (characterObject.getVar().getBool(2) == true)
                    {
                        characterObject.sq_WriteDword(1);
                        characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(137, 137, 1, 1.0 + bonusRate));
                        characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(137, 137, 2, 1.0 + bonusRate));
                    }
                    else
                    {
                        characterObject.sq_WriteDword(2);
                        characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(137, 137, 1, 1.0));
                        characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(137, 137, 2, 1.0));
                    }
                    characterObject.sq_WriteDword(characterObject.getVar().get_vector(0));
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 120, -1, 0);
                    sq_SetMyShake(characterObject, 2, 1000);
                    sq_flashScreen(characterObject, 0, 200, 500, 255, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                }
                sq_CreateDrawOnlyObject(characterObject, "character/priest/effect/animation/doomcrush/doomcrush_boom_finish_glow.ani", ENUM_DRAWLAYER_NORMAL, true);
            }
            break;
    }
    return true;
}

/**
 * 當前動畫結束處理
 * @param {SQRCharacter} characterObject - 角色物件
 */
function onEndCurrentAni_priest_doomcrush(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if (!characterObject) return;
    if (!characterObject.sq_IsMyControlObject()) return;

    local subState = characterObject.getSkillSubState();
    switch (subState)
    {
        case 0:
        case 1:
            local skillLevel = sq_GetSkillLevel(characterObject, 137);
            local attackCount = characterObject.sq_GetLevelData(137, 3, skillLevel);
            local gaugeConsume = 0;
            if (characterObject.getVar().getBool(0) == true)
            {
                local currentGauge = getDevilGauge(characterObject);
                if (isInDevilStrikeSkill(characterObject) && currentGauge > 0)
                {
                    if (!CNSquirrelAppendage.sq_IsAppendAppendage(characterObject, "character/xinghe/priest/metamorphosis/ap_metamorphosis.nut"))
                        gaugeConsume = characterObject.sq_GetLevelData(137, 4, skillLevel);
                    attackCount = sq_GetUniformVelocity(attackCount, characterObject.sq_GetLevelData(137, 5, skillLevel), currentGauge, gaugeConsume);
                }
                else
                    characterObject.getVar().setBool(0, false);
            }
            characterObject.sq_IntVectClear();
            characterObject.sq_IntVectPush(2);
            if (characterObject.getVar().getBool(0) == true)
                characterObject.sq_IntVectPush(1);
            else
                characterObject.sq_IntVectPush(0);
            characterObject.sq_IntVectPush(attackCount);
            characterObject.sq_IntVectPush(gaugeConsume);
            characterObject.sq_AddSetStatePacket(137, STATE_PRIORITY_USER, true);
            break;
        case 2:
            if (!isAvengerAwakenning(characterObject))
            {
                characterObject.sq_IntVectClear();
                characterObject.sq_IntVectPush(3);
                characterObject.sq_AddSetStatePacket(137, STATE_PRIORITY_USER, true);
            }
            else
                characterObject.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
        case 3:
            characterObject.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
}

// ---------------------codeEnd---------------------//