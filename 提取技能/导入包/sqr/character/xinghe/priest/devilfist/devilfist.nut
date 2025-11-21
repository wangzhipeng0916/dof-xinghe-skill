// ---------------------codeStart---------------------//

/**
 * 檢查是否可執行驅魔師惡魔拳技能
 * @param {SQRCharacter} characterObject - 角色物件
 * @return {boolean} 是否可執行技能
 */
function checkExecutableSkill_priest_devilfist(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false;
    
    local isSkillUsed = characterObject.sq_IsUseSkill(SKILL_PRIEST_DEVILFIST);
    if(isSkillUsed)
    {
        characterObject.sq_IntVectClear();
        if(isAvengerAwakenning(characterObject))
            characterObject.sq_IntVectPush(1);
        else
            characterObject.sq_IntVectPush(0);
        characterObject.sq_AddSetStatePacket(STATE_PRIEST_DEVILFIST, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查驅魔師惡魔拳技能命令是否可用
 * @param {SQRCharacter} characterObject - 角色物件
 * @return {boolean} 命令是否可用
 */
function checkCommandEnable_priest_devilfist(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false;
    
    local currentState = characterObject.sq_GetState();
    if(currentState == STATE_STAND)
        return true;
    if(currentState == STATE_ATTACK)
    {
        return characterObject.sq_IsCommandEnable(135);
    }
    return true;
}

/**
 * 設定驅魔師惡魔拳技能狀態
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {integer} state - 狀態
 * @param {object} skillData - 技能資料
 * @param {object} customData - 自訂資料
 */
function onSetState_priest_devilfist(characterObject, state, skillData, customData)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return;
    
    characterObject.sq_StopMove();
    local subState = characterObject.sq_GetVectorData(skillData, 0);
    characterObject.setSkillSubState(subState);
    
    switch(subState)
    {
        case 0:
            characterObject.sq_SetCurrentAnimation(CUSTOM_ANI_PRIEST_DEVILFIST_BODY);
            characterObject.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_PRIEST_DEVILFIST);
            characterObject.sq_SetCurrentAttackBonusRate(characterObject.sq_GetBonusRateWithPassive(135, 135, 1, 1.0));
            break;
        case 1:
            local animationMap = characterObject.getVar().GetAnimationMap("priest_avenger_devilfistavenger_body", "character/priest/animation/avengerawakening/devilfistavenger_body.ani");
            characterObject.setCurrentAnimation(animationMap);
            characterObject.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_PRIEST_DEVILFISTAWAKENING);
            characterObject.sq_SetCurrentAttackBonusRate(characterObject.sq_GetBonusRateWithPassive(135, 135, 4, 1.0));
            break;
    }
    
    characterObject.getVar().setBool(0, false);
    local originalDelay = characterObject.sq_GetDelaySum();
    characterObject.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    local currentDelay = characterObject.sq_GetDelaySum();
    local speedRate = originalDelay.tofloat() / currentDelay.tofloat() * 100.0;
    characterObject.getVar("speedRate").setFloat(0, speedRate);
    
    switch(subState)
    {
        case 0:
            local backDust = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/human/backdust_11.ani", ENUM_DRAWLAYER_NORMAL, characterObject.getXPos(), characterObject.getYPos() - 1, characterObject.getZPos(), false, speedRate);
            local frontDust = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/human/frontdust_00.ani", ENUM_DRAWLAYER_NORMAL, characterObject.getXPos(), characterObject.getYPos(), characterObject.getZPos(), false, speedRate);
            local floorSpin = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/human/floorspin_02.ani", ENUM_DRAWLAYER_BOTTOM, characterObject.getXPos(), characterObject.getYPos(), characterObject.getZPos(), false, speedRate);
            sq_moveWithParent(characterObject, backDust);
            sq_moveWithParent(characterObject, frontDust);
            sq_moveWithParent(characterObject, floorSpin);
            characterObject.getVar("aniobj").push_obj_vector(backDust);
            characterObject.getVar("aniobj").push_obj_vector(frontDust);
            characterObject.getVar("aniobj").push_obj_vector(floorSpin);
            break;
        case 1:
            local backDust = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/devil/backdust_11.ani", ENUM_DRAWLAYER_NORMAL, characterObject.getXPos(), characterObject.getYPos() - 1, characterObject.getZPos(), false, speedRate);
            local frontDust = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/devil/frontdust_00.ani", ENUM_DRAWLAYER_NORMAL, characterObject.getXPos(), characterObject.getYPos(), characterObject.getZPos(), false, speedRate);
            local floorSpin = CreateAniRate(characterObject, "character/priest/effect/animation/devilfist/devil/floorspin_02.ani", ENUM_DRAWLAYER_BOTTOM, characterObject.getXPos(), characterObject.getYPos(), characterObject.getZPos(), false, speedRate);
            sq_moveWithParent(characterObject, backDust);
            sq_moveWithParent(characterObject, frontDust);
            sq_moveWithParent(characterObject, floorSpin);
            characterObject.getVar("aniobj").push_obj_vector(backDust);
            characterObject.getVar("aniobj").push_obj_vector(frontDust);
            characterObject.getVar("aniobj").push_obj_vector(floorSpin);
            break;
    }
}

/**
 * 驅魔師惡魔拳技能攻擊處理
 * @param {SQRCharacter} attacker - 攻擊者
 * @param {object} target - 目標物件
 * @param {object} attackInfo - 攻擊資訊
 * @param {boolean} isCounterAttack - 是否反擊
 */
function onAttack_priest_devilfist(attacker, target, attackInfo, isCounterAttack)
{
    attacker = sq_GetCNRDObjectToSQRCharacter(attacker);
    if(!attacker) return;
    if(isCounterAttack || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    
    if(sq_IsGrabable(attacker, target)
        && sq_IsHoldable(attacker, target)
        && !sq_IsFixture(target)
        && !CNSquirrelAppendage.sq_IsAppendAppendage(target, "character/xinghe/priest/devilfist/ap_devilfist.nut"))
    {
        local distance = attacker.getXDistance(target);
        if(distance < 160) distance = 160;
        local appendage = CNSquirrelAppendage.sq_AppendAppendage(target, attacker, SKILL_PRIEST_DEVILFIST, false, "character/xinghe/priest/devilfist/ap_devilfist.nut", true);
        sq_MoveToAppendage(target, attacker, attacker, distance + 1, 1, 0, 150, true, appendage);
        appendage.sq_SetValidTime(150);
    }
    
    if(attacker.getVar().getBool(0) == false)
    {
        attacker.getVar().setBool(0, true);
        local hitEffect = sq_CreateDrawOnlyObject(attacker, "character/priest/effect/animation/devilfist/hit_00.ani", ENUM_DRAWLAYER_NORMAL, true);
        hitEffect.setCurrentPos(target.getXPos(), target.getYPos(), target.getZPos() + sq_GetCenterZPos(attackInfo));
    }
}

/**
 * 驅魔師惡魔拳技能結束狀態處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {integer} previousState - 先前狀態
 */
function onEndState_priest_devilfist(characterObject, previousState)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return;
    
    if(previousState != 135 && previousState != STATE_STAND)
        RemoveAllAni(characterObject);
}

/**
 * 驅魔師惡魔拳技能關鍵幀標誌處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {integer} flag - 標誌值
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_devilfist(characterObject, flag)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false;
    
    local subState = characterObject.getSkillSubState();
    
    switch(subState)
    {
        case 0:
        case 1:
            if(flag == 0)
            {
                local hitCount = characterObject.sq_GetLevelData(SKILL_PRIEST_DEVILFIST, 0 + (subState * 3), sq_GetSkillLevel(characterObject, SKILL_PRIEST_DEVILFIST));
                local timeInterval = characterObject.getCurrentAnimation().getDelaySum(9, 18);
                characterObject.setTimeEvent(0, timeInterval / hitCount, hitCount - 1, false);
            }
            break;
    }
    
    switch(subState)
    {
        case 0:
            if(flag == 1)
                sq_SetMyShake(characterObject, 4, 400);
            else if(flag == 2)
            {
                if(characterObject.sq_IsMyControlObject())
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(135);
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(135, 135, 2, 1.0));
                    characterObject.sq_WriteFloat(1.0);
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 189, 1, 62);
                }
            }
            break;
        case 1:
            if(flag == 1)
                sq_SetMyShake(characterObject, 5, 400);
            else if(flag == 2)
            {
                if(characterObject.sq_IsMyControlObject())
                {
                    characterObject.sq_StartWrite();
                    characterObject.sq_WriteDword(135);
                    characterObject.sq_WriteDword(characterObject.sq_GetBonusRateWithPassive(135, 135, 5, 1.0));
                    characterObject.sq_WriteFloat(1.25);
                    characterObject.sq_SendCreatePassiveObjectPacket(24374, 0, 236, 1, 82);
                }
            }
            break;
    }
    return true;
}

/**
 * 驅魔師惡魔拳技能時間事件處理
 * @param {SQRCharacter} characterObject - 角色物件
 * @param {integer} eventId - 事件ID
 * @param {integer} count - 計數
 * @return {boolean} 處理結果
 */
function onTimeEvent_priest_devilfist(characterObject, eventId, count)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return false;
    
    if(eventId == 0)
    {
        characterObject.getVar().setBool(0, false);
        characterObject.resetHitObjectList();
    }
    return false;
}

/**
 * 驅魔師惡魔拳技能當前動畫結束處理
 * @param {SQRCharacter} characterObject - 角色物件
 */
function onEndCurrentAni_priest_devilfist(characterObject)
{
    characterObject = sq_GetCNRDObjectToSQRCharacter(characterObject);
    if(!characterObject) return;
    
    if(characterObject.sq_IsMyControlObject())
        characterObject.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

// ---------------------codeEnd---------------------//