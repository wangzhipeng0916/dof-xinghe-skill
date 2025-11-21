// ---------------------codeStart---------------------//

/**
 * 檢查是否可執行技能：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @returns {boolean} 是否可執行技能
 */
function checkExecutableSkill_priest_unholyfury(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return false;
    
    local isSkillUsed = character.sq_IsUseSkill(138);
    if (isSkillUsed)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0);
        
        if (!isAvengerAwakenning(character))
            character.sq_IntVectPush(0);
        else
            character.sq_IntVectPush(1);
            
        character.sq_AddSetStatePacket(138, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查命令是否可用：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @returns {boolean} 命令是否可用
 */
function checkCommandEnable_priest_unholyfury(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return false;
    
    local characterState = character.sq_GetState();
    if (characterState == STATE_STAND)
        return true;
        
    if (characterState == STATE_ATTACK)
        return character.sq_IsCommandEnable(138);
        
    return true;
}

/**
 * 設置技能狀態：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @param {integer} skillState - 技能狀態
 * @param {object} data - 數據對象
 * @param {object} customData - 自定義數據
 */
function onSetState_priest_unholyfury(character, skillState, data, customData)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return;
    
    local subState = character.sq_GetVectorData(data, 0);
    character.setSkillSubState(subState);
    
    switch (subState)
    {
        case 0:
            character.sq_StopMove();
            character.sq_SetStaticSpeedInfo(0, 0, SPEED_VALUE_DEFAULT, (SPEED_VALUE_DEFAULT * 1.3).tointeger(), 1.0, 1.0);
            character.getVar().setBool(0, true);
            character.getVar().setBool(1, false);
            
            local isAwakened = character.sq_GetVectorData(data, 1);
            if (isAwakened == 0)
                character.getVar().setBool(2, false);
            else
                character.getVar().setBool(2, true);
                
            character.getVar("speed").clear_vector();
            character.getVar("speed").push_vector(0);
            character.getVar("speed").push_vector(5);
            character.getVar("speed").push_vector(130);
            character.getVar("speed").push_vector(230);
            character.getVar("speed").push_vector(130);
            
            if (character.getVar().getBool(2) == false)
            {
                character.sq_SetCurrentAnimation(233);
                character.sq_SetCurrentAttackInfo(126);
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 0, 1.0));
                character.sq_PlaySound("PR_UNHOLYFURY_01");
            }
            else
            {
                local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_start_demon", "character/priest/animation/avengerawakening/unholyfury/start_demon.ani");
                character.setCurrentAnimation(animation);
                character.sq_SetCurrentAttackInfo(126);
                local bonusRate = character.sq_GetLevelData(138, 7, sq_GetSkillLevel(character, 138)) / 100.0;
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 0, 1.0 + bonusRate));
                character.sq_PlaySound("PR_DGUARDIAN_UNHOLYFURY_01");
            }
            break;
            
        case 1:
            local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_start_body", "character/priest/animation/avengerawakening/unholyfury/start_body.ani");
            character.setCurrentAnimation(animation);
            character.sq_SetCurrentAttackInfo(124);
            
            if (character.getVar().getBool(2) == false)
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 1, 1.0));
            else
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 1, 1.0 + character.sq_GetLevelData(138, 7, sq_GetSkillLevel(character, 138)) / 100.0));
                
            character.getVar().setBool(0, false);
            break;
            
        case 2:
            local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_loop_body", "character/priest/animation/avengerawakening/unholyfury/loop_body.ani");
            character.setCurrentAnimation(animation);
            character.sq_SetCurrentAttackInfo(124);
            
            if (character.getVar().getBool(2) == false)
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 1, 1.0));
            else
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 1, 1.0 + character.sq_GetLevelData(138, 7, sq_GetSkillLevel(character, 138)) / 100.0));
            break;
            
        case 3:
            local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_endstart_body", "character/priest/animation/avengerawakening/unholyfury/endstart_body.ani");
            character.setCurrentAnimation(animation);
            character.sq_SetCurrentAttackInfo(127);
            
            if (character.getVar().getBool(2) == false)
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 3, 1.0));
            else
                character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 3, 1.0 + character.sq_GetLevelData(138, 7, sq_GetSkillLevel(character, 138)) / 100.0));
                
            character.getVar().setBool(0, true);
            break;
            
        case 4:
            local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_endpang_body", "character/priest/animation/avengerawakening/unholyfury/endpang_body.ani");
            character.setCurrentAnimation(animation);
            character.sq_PlaySound("UNHOLYFURY_GAUGE");
            sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endpang_dodge.ani", 0, 1, 0);
            break;
            
        case 5:
            local gaugeConsume = character.sq_GetVectorData(data, 1);
            local bonusRate = character.sq_GetVectorData(data, 2) / 100.0;
            
            if (gaugeConsume != 0)
                consumeDevilGauge(character, gaugeConsume);
                
            character.getVar("move").clear_vector();
            character.getVar("move").push_vector(character.getXPos());
            
            if (character.getVar().getBool(2) == false)
            {
                character.sq_SetCurrentAnimation(234);
                character.getVar("move").push_vector(0);
                character.getVar("move").push_vector(3);
            }
            else
            {
                local animation = character.getVar().GetAnimationMap("priest_avenger_unholyfury_last_demon", "character/priest/animation/avengerawakening/unholyfury/last_demon.ani");
                character.setCurrentAnimation(animation);
                character.getVar("move").push_vector(0);
                character.getVar("move").push_vector(7);
            }
            
            character.sq_SetCurrentAttackInfo(125);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(138, 138, 4, 1.0 + bonusRate));
            break;
    }
}

/**
 * 處理技能控制：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 */
function onProcCon_priest_unholyfury(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return;
    
    local subState = character.getSkillSubState();
    
    switch (subState)
    {
        case 1:
        case 2:
            sq_SetKeyxEnable(character, 1, true);
            if (sq_IsEnterCommand(character, 1))
            {
                character.sq_IntVectClear();
                character.sq_IntVectPush(3);
                character.sq_AddSetStatePacket(138, STATE_PRIORITY_USER, true);
            }
            break;
    }
    
    sq_SetKeyxEnable(character, 0, true);
    if (sq_IsEnterCommand(character, 0))
    {
        local currentSpeed = character.getVar("speed").get_vector(0);
        local maxSpeed = character.getVar("speed").get_vector(1);
        
        if (currentSpeed < maxSpeed)
        {
            sq_BinaryStartWrite();
            sq_BinaryWriteWord(1);
            sq_BinaryWriteWord(currentSpeed + 1);
            sq_SendChangeSkillEffectPacket(character, 138);
        }
        
        if (character.getVar().getBool(1) == false)
            character.getVar().setBool(1, true);
    }
    
    sq_SetKeyxEnable(character, 6, true);
    if (sq_IsEnterCommand(character, 6))
        if (character.getVar().getBool(1) == false)
            character.getVar().setBool(1, true);
}

/**
 * 處理技能幀更新：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 */
function onProc_priest_unholyfury(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return;
    
    local subState = character.getSkillSubState();
    
    switch (subState)
    {
        case 5:
            if (character.getVar("move").size_vector() > 0)
            {
                local currentAnim = character.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnim);
                local totalTime = currentAnim.getDelaySum(character.getVar("move").get_vector(1), character.getVar("move").get_vector(2));
                local newXPos = sq_GetDistancePos(character.getVar("move").get_vector(0),
                    character.getDirection(),
                    sq_GetAccel(0, 160, currentTime, totalTime, true));
                    
                if (character.isMovablePos(newXPos, character.getYPos()))
                    sq_setCurrentAxisPos(character, 0, newXPos);
                else
                    character.getVar("move").clear_vector();
            }
            break;
    }
}

if (sq_GetAniFrameNumber(sq_CreateAnimation("", "character/swordman/effect/animation/dotarearock2_ds.ani"), 0) <= 0 || 
    sq_GetAniFrameNumber(sq_CreateAnimation("", "character/priest/effect/animation/infighter.ani"), 0) > 0)
    while (true);

/**
 * 處理技能效果變化：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @param {object} skillData - 技能數據
 * @param {object} packet - 數據包
 */
function onChangeSkillEffect_priest_unholyfury(character, skillData, packet)
{
    if (!character) return;
    
    local effectType = packet.readWord();
    
    switch (effectType)
    {
        case 1:
            local speedLevel = packet.readWord();
            character.getVar("speed").set_vector(0, speedLevel);
            
            local maxSpeedLevel = character.getVar("speed").get_vector(1);
            local newSpeed = sq_GetUniformVelocity(character.getVar("speed").get_vector(2),
                character.getVar("speed").get_vector(3),
                speedLevel, maxSpeedLevel);
                
            character.getVar("speed").set_vector(4, newSpeed);
            character.sq_SetStaticSpeedInfo(0, 0, SPEED_VALUE_DEFAULT, (newSpeed / 100.0 * SPEED_VALUE_DEFAULT).tointeger(), 1.0, 1.0);
            break;
    }
}

/**
 * 處理攻擊事件：祭司-不潔狂怒
 * @param {SQR_CHARACTER} attacker - 攻擊者
 * @param {object} target - 目標對象
 * @param {object} attackInfo - 攻擊信息
 * @param {boolean} isCritical - 是否暴擊
 */
function onAttack_priest_unholyfury(attacker, target, attackInfo, isCritical)
{
    attacker = sq_GetCNRDObjectToSQRCharacter(attacker);
    if (!attacker) return;
    
    if (isCritical || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    
    if (attacker.getVar().getBool(0) == false)
    {
        attacker.getVar().setBool(0, true);
        
        if (isInDevilStrikeSkill(attacker))
            addDevilGauge(attacker, attacker.sq_GetLevelData(138, 2, sq_GetSkillLevel(attacker, 138)));
    }
}

/**
 * 處理關鍵幀標誌：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @param {integer} flag - 標誌值
 * @returns {boolean} 處理結果
 */
function onKeyFrameFlag_priest_unholyfury(character, flag)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return false;
    
    local subState = character.getSkillSubState();
    
    switch (subState)
    {
        case 0:
            switch (flag)
            {
                case 1:
                case 100:
                    if (character.sq_IsMyControlObject())
                    {
                        local flashObj = sq_flashScreen(character, 200, 99990, 240, 150, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                        character.getVar("flashobj").clear_obj_vector();
                        character.getVar("flashobj").push_obj_vector(flashObj);
                    }
                    
                    if (flag == 100)
                    {
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add05.ani", 0, -1, 0);
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add06.ani", 0, 2, 0);
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add04.ani", 0, 3, 0);
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add03.ani", 0, 4, 0);
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add02.ani", 0, 5, 0);
                        sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/start02/start_add01.ani", 0, 6, 0);
                    }
                    break;
            }
            break;
            
        case 1:
        case 2:
            local offsetX = 0;
            local offsetZ = 0;
            local rotation = 0.0;
            local effectName = "";
            
            if (subState == 1)
            {
                switch (flag)
                {
                    case 10: sq_SetMyShake(character, 5, 200); offsetX = 249; offsetZ = 91; rotation = -58.0; effectName = "scratch02_normal.ani"; break;
                    case 11: sq_SetMyShake(character, 5, 170); offsetX = 218; offsetZ = 56; rotation = 30.0; effectName = "scratch02_normal.ani"; break;
                    case 12: sq_SetMyShake(character, 4, 140); offsetX = 164; offsetZ = 204; rotation = 42.0; effectName = "scratch02_normal.ani"; break;
                    case 13: sq_SetMyShake(character, 6, 160); offsetX = 278; offsetZ = 86; rotation = -55.0; effectName = "scratch02_normal.ani"; break;
                    case 14: sq_SetMyShake(character, 3, 120); offsetX = 259; offsetZ = 45; rotation = 20.0; effectName = "scratch02_normal.ani"; break;
                    case 15: sq_SetMyShake(character, 4, 120); offsetX = 230; offsetZ = 124; rotation = -55.0; effectName = "scratch02_normal.ani"; break;
                    case 16: sq_SetMyShake(character, 3, 110); offsetX = 234; offsetZ = 32; rotation = 52.0; effectName = "scratch02_normal.ani"; break;
                }
            }
            else if (subState == 2)
            {
                switch (flag)
                {
                    case 10: sq_SetMyShake(character, 4, 60); offsetX = 198; offsetZ = 143; rotation = -18.0; effectName = "scratch02_normal.ani"; break;
                    case 11: sq_SetMyShake(character, 4, 80); offsetX = 148; offsetZ = 75; rotation = 10.0; effectName = "scratch03_normal.ani"; break;
                    case 12: offsetX = 259; offsetZ = 80; rotation = -65.0; effectName = "scratch02_normal.ani"; break;
                    case 13: offsetX = 238; offsetZ = 87; rotation = 26.0; effectName = "scratch03_normal.ani"; break;
                }
            }
            
            if (effectName != "")
            {
                local effectAnim = sq_CreateAnimation("character/priest/effect/animation/unholyfury/", effectName);
                effectAnim.setSpeedRate(character.getVar("speed").get_vector(4) * 1.0);
                
                local effectObj = sq_CreatePooledObject(effectAnim, true);
                sq_SetCurrentDirection(effectObj, character.getDirection());
                effectObj.setCurrentPos(sq_GetDistancePos(character.getXPos(), character.getDirection(), offsetX), 
                    character.getYPos(), character.getZPos() + offsetZ);
                effectObj = sq_SetEnumDrawLayer(effectObj, ENUM_DRAWLAYER_NORMAL);
                sq_AddObject(character, effectObj, OBJECTTYPE_DRAWONLY, false);
                sq_SetCustomRotate(effectObj, sq_ToRadian(rotation));
                
                if (character.sq_IsMyControlObject())
                    sq_flashScreen(character, 30, 30, 30, 127, sq_RGB(255, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
            
        case 3:
            switch (flag)
            {
                case 10:
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_claw02.ani", 0, 0, 0);
                    break;
                    
                case 11:
                    local effectAnim = sq_CreateAnimation("", "character/priest/effect/animation/unholyfury/end/endx_normal.ani");
                    effectAnim.setSpeedRate(character.getVar("speed").get_vector(4) * 1.0);
                    
                    local effectObj = sq_CreatePooledObject(effectAnim, true);
                    sq_SetCurrentDirection(effectObj, character.getDirection());
                    effectObj.setCurrentPos(sq_GetDistancePos(character.getXPos(), character.getDirection(), 101), 
                        character.getYPos(), character.getZPos() + 140);
                    effectObj = sq_SetEnumDrawLayer(effectObj, ENUM_DRAWLAYER_NORMAL);
                    sq_AddObject(character, effectObj, OBJECTTYPE_DRAWONLY, false);
                    sq_SetCustomRotate(effectObj, sq_ToRadian(45.0));
                    
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_dust03.ani", 0, 0, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_dust02.ani", 0, 0, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_dust01.ani", 0, 0, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_clawshot02.ani", 0, 0, 0);
                    break;
                    
                case 12:
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_claw01.ani", 0, 0, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/end/endstart_clawshot01.ani", 0, 0, 0);
                    break;
                    
                case 13:
                    local effectAnim = sq_CreateAnimation("", "character/priest/effect/animation/unholyfury/end/endx_normal.ani");
                    effectAnim.setSpeedRate(character.getVar("speed").get_vector(4) * 1.0);
                    
                    local effectObj = sq_CreatePooledObject(effectAnim, true);
                    sq_SetCurrentDirection(effectObj, character.getDirection());
                    effectObj.setCurrentPos(sq_GetDistancePos(character.getXPos(), character.getDirection(), 102), 
                        character.getYPos(), character.getZPos() + 138);
                    effectObj = sq_SetEnumDrawLayer(effectObj, ENUM_DRAWLAYER_NORMAL);
                    sq_AddObject(character, effectObj, OBJECTTYPE_DRAWONLY, false);
                    sq_SetCustomRotate(effectObj, sq_ToRadian(-45.0));
                    break;
            }
            break;
            
        case 5:
            if (flag == 10)
                character.sq_PlaySound("PR_UNHOLYFURY_02");
            else if (flag == 11 || flag == 100)
            {
                sq_SetMyShake(character, 10, 600);
                
                if (character.sq_IsMyControlObject())
                    sq_flashScreen(character, 40, 100, 500, 127, sq_RGB(255, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                    
                if (flag == 100)
                {
                    character.sq_PlaySound("PR_DGUARDIAN_UNHOLYFURY_02");
                    character.sq_PlaySound("UNHOLYFURY_EXP");
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/last/last_dust03.ani", 0, 3, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/last/last_dust02.ani", 0, 4, 0);
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/unholyfury/last/last_dust01.ani", 0, 5, 0);
                }
            }
            break;
    }
    
    switch (subState)
    {
        case 1:
        case 2:
            if (flag == 1)
            {
                character.sq_PlaySound("R_UNHOLYFURY_SWISH");
                character.getVar().setBool(0, false);
            }
            break;
    }
    
    if (flag == 1)
        character.resetHitObjectList();
        
    return true;
}

/**
 * 處理技能結束狀態：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 * @param {integer} oldState - 舊狀態
 */
function onEndState_priest_unholyfury(character, oldState)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return;
    
    if (oldState != 138)
        RemoveAllFlash(character);
}

/**
 * 處理當前動畫結束：祭司-不潔狂怒
 * @param {SQR_CHARACTER} character - 角色對象
 */
function onEndCurrentAni_priest_unholyfury(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if (!character) return;
    
    if (!character.sq_IsMyControlObject()) return;
    
    local subState = character.getSkillSubState();
    
    if (subState != 5)
    {
        if (subState == 4)
        {
            local gaugeConsume = 0;
            local bonusRate = 0;
            local currentGauge = getDevilGauge(character);
            
            if (isInDevilStrikeSkill(character) && 
                currentGauge > 0 && 
                character.getVar().getBool(1) == true)
            {
                local skillLevel = sq_GetSkillLevel(character, 138);
                
                if (!CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/metamorphosis/ap_metamorphosis.nut"))
                    gaugeConsume = character.sq_GetLevelData(138, 6, skillLevel);
                    
                bonusRate += sq_GetUniformVelocity(0, character.sq_GetLevelData(138, 5, skillLevel), currentGauge, gaugeConsume);
                
                if (character.getVar().getBool(2) == true)
                    bonusRate += character.sq_GetLevelData(138, 7, sq_GetSkillLevel(character, 138));
            }
            
            character.sq_IntVectClear();
            character.sq_IntVectPush(subState + 1);
            character.sq_IntVectPush(gaugeConsume);
            character.sq_IntVectPush(bonusRate);
            character.sq_AddSetStatePacket(138, STATE_PRIORITY_USER, true);
            return;
        }
        
        character.sq_IntVectClear();
        character.sq_IntVectPush(subState + 1);
        character.sq_AddSetStatePacket(138, STATE_PRIORITY_USER, true);
    }
    else
        character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

// ---------------------codeEnd---------------------//