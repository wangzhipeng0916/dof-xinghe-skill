// ---------------------codeStart---------------------// 

// 職業：聖職者 - 變身技能相關函數

/**
 * 檢查是否可以執行變身技能
 * @param {SQRCharacter} character - 角色對象
 * @return {boolean} 是否可以執行技能
 */
function checkExecutableSkill_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return false;
    
    if(isAvengerAwakenning(character) 
        || !isInDevilStrikeSkill(character) 
        || CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut")) 
        return false;
    
    if(getDevilGauge(character).tofloat() / getDevilMaxGaugeValue(character).tofloat() >=
        character.sq_GetLevelData(139, 6, sq_GetSkillLevel(character, 139)) / 100.0) 
    {
        local isSkillUsed = character.sq_IsUseSkill(139);
        if(isSkillUsed) 
        {
            character.sq_IntVectClear();
            character.sq_IntVectPush(0);
            character.sq_AddSetStatePacket(139, STATE_PRIORITY_USER, true);
            return true;
        }
    }
    else if(character.isMessage())
        sq_AddMessage(29002);
    
    return false;
}

/**
 * 檢查變身技能命令是否可用
 * @param {SQRCharacter} character - 角色對象
 * @return {boolean} 命令是否可用
 */
function checkCommandEnable_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return false;
    
    if(isAvengerAwakenning(character) 
        || !isInDevilStrikeSkill(character) 
        || CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut")) 
        return false;
    
    local characterState = character.sq_GetState();
    if(characterState == STATE_STAND) 
        return true;
    if(characterState == STATE_ATTACK) 
        return character.sq_IsCommandEnable(139);
    
    return true;
}

/**
 * 設置變身技能狀態
 * @param {SQRCharacter} character - 角色對象
 * @param {number} state - 狀態類型
 * @param {table} data - 狀態數據
 * @param {table} customData - 自定義數據
 */
function onSetState_priest_metamorphosis(character, state, data, customData)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return;
    
    character.sq_StopMove();
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
    
    local subState = character.sq_GetVectorData(data, 0);
    character.setSkillSubState(subState);
    
    switch(subState)
    {
        case 0:
            character.sq_SetCurrentAnimation(235);
            character.sq_PlaySound("PR_METAMORPHOSIS");
            if(character.sq_IsMyControlObject())
            {
                character.sq_StartWrite();
                character.sq_WriteDword(139);
                character.sq_WriteDword(1);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(139, 139, 9, 1.0));
                character.sq_WriteDword(character.sq_GetLevelData(139, 10, sq_GetSkillLevel(character, 139)));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
            }
            break;
            
        case 1:
            character.sq_SetCurrentAnimation(242);
            character.sq_SetCurrentAttackInfo(134);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(139, 20, 1, 2.5));
            break;
            
        case 2:
            character.sq_SetCurrentAnimation(240);
            character.sq_SetCurrentAttackInfo(133);
            local attackInfo = sq_GetCurrentAttackInfo(character);
            sq_SetCurrentAttackBonusRate(attackInfo, character.sq_GetBonusRateWithPassive(63, 30, 0, 1.5));
            sq_SetCurrentAttackPower(attackInfo, character.sq_GetPowerWithPassive(63, 30, 2, 0, 1.5));
            sq_SetCurrentAttacknUpForce(attackInfo, character.sq_GetLevelData(63, 1, sq_GetSkillLevel(character, 63)));
            character.getVar("move").clear_vector();
            character.getVar("move").push_vector(character.getXPos());
            break;
            
        case 3:
            character.sq_SetCurrentAnimation(244);
            character.sq_SetCurrentAttackInfo(142);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(11, 26, 0, 5.0));
            character.getVar("move").clear_vector();
            character.getVar("move").push_vector(character.getZPos());
            character.getVar().setBool(0, false);
            if(character.sq_IsMyControlObject())
            {
                character.sq_SetStaticMoveInfo(0, 200, 200, true);
                character.sq_SetMoveDirection(character.getDirection(), ENUM_DIRECTION_NEUTRAL);
            }
            character.sq_PlaySound("PR_MINE");
            break;
    }
}

/**
 * 變身技能持續處理 - 控制相關
 * @param {SQRCharacter} character - 角色對象
 */
function onProcCon_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return;
    
    local subState = character.getSkillSubState();
    switch(subState)
    {
        case 1:
            character.setSkillCommandEnable(169, true);
            if(character.sq_IsEnterSkill(169) != -1) 
            {
                local isSkillUsed = character.sq_IsUseSkill(169);
                if(isSkillUsed)
                {
                    character.sq_IntVectClear();
                    character.sq_IntVectPush(1);
                    character.sq_IntVectPush(1);
                    character.sq_IntVectPush(200);
                    character.sq_AddSetStatePacket(STATE_JUMP, STATE_PRIORITY_USER, true);
                }
            }
            break;
    }
}

/**
 * 變身技能持續處理
 * @param {SQRCharacter} character - 角色對象
 */
function onProc_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return;
    
    local subState = character.getSkillSubState();
    switch(subState)
    {
        case 2:
            if(character.getVar("move").size_vector() > 0)
            {
                local currentAnim = character.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnim);
                local totalTime = currentAnim.getDelaySum(0, 1);
                local newXPos = sq_GetDistancePos(character.getVar("move").get_vector(0),
                    character.getDirection(),
                    sq_GetUniformVelocity(0, 45, currentTime, totalTime));
                if(character.isMovablePos(newXPos, character.getYPos()))
                    sq_setCurrentAxisPos(character, 0, newXPos);
                else
                    character.getVar("move").clear_vector();
            }
            break;
            
        case 3:
            if(character.getVar("move").size_vector() == 1)
            {
                local currentAnim = character.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnim);
                local totalTime = currentAnim.getDelaySum(0, 4);
                local newZPos = sq_GetAccel(character.getVar("move").get_vector(0), 135, currentTime, totalTime, true);
                sq_setCurrentAxisPos(character, 2, newZPos);
                if(currentTime >= totalTime)
                {
                    character.sq_PlaySound("MINE_EFFECT");
                    sq_SetZVelocity(character, -700, -700);
                    character.getVar("move").clear_vector();
                }
            }
            else
            {
                if(character.getZPos() <= 0 && character.getVar().getBool(0) == false)
                {
                    character.getVar().setBool(0, true);
                    character.sq_StopMove();
                    local currentAnim = character.getCurrentAnimation();
                    sq_Rewind(currentAnim);
                    currentAnim.setCurrentFrameWithChildLayer(8);
                    if(character.sq_IsMyControlObject())
                    {
                        character.sq_StartWrite();
                        character.sq_WriteDword(139);
                        character.sq_WriteDword(2);
                        character.sq_WriteDword(character.sq_GetBonusRateWithPassive(11, 26, 0, 10.0));
                        character.sq_WriteDword(100);
                        character.sq_SendCreatePassiveObjectPacket(24374, 0, 45, 0, 0);
                    }
                }
            }
            break;
    }
}

/**
 * 處理關鍵幀標誌
 * @param {SQRCharacter} character - 角色對象
 * @param {number} flag - 關鍵幀標誌
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_metamorphosis(character, flag)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return false;
    
    local subState = character.getSkillSubState();
    switch(subState)
    {
        case 0:
            if(flag == 0)
            {
                sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/metamorphosis/effect/change.ani", ENUM_DRAWLAYER_NORMAL, true);
                sq_SetMyShake(character, 5, 60);
                if(character.sq_IsMyControlObject())
                    sq_flashScreen(character, 0, 160, 80, 204, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
            }
            break;
            
        case 1:
            if(flag == 0)
                sq_SetMyShake(character, 5, 60);
            else if(flag == 1)
            {
                character.resetHitObjectList();
                sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/metamorphosis/attack/z/zattack_dust.ani", ENUM_DRAWLAYER_NORMAL, true);
            }
            break;
            
        case 2:
            if(flag == 0)
            {
                sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/metamorphosis/attack/dash02/dash02_dust.ani", ENUM_DRAWLAYER_NORMAL, true);
                sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/metamorphosis/effect/upper.ani", ENUM_DRAWLAYER_NORMAL, true);
            }
            else if(flag == 1)
                character.resetHitObjectList();
            break;
    }
    return true;
}

// 動畫檢查代碼
if(sq_GetAniFrameNumber(sq_CreateAnimation("", "character/swordman/effect/animation/dotarearock2_ds.ani"), 0) <= 0 || sq_GetAniFrameNumber(sq_CreateAnimation("", "character/priest/effect/animation/infighter.ani"), 0) > 0)while(true);

/**
 * 當前動畫結束時處理
 * @param {SQRCharacter} character - 角色對象
 */
function onEndCurrentAni_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return;
    if(!character.sq_IsMyControlObject()) return;
    
    local subState = character.getSkillSubState();
    switch(subState)
    {
        case 0:
        case 1:
        case 2:
        case 3:
            if(subState == 0 && !CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut"))
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteWord(1);
                sq_SendChangeSkillEffectPacket(character, 139);
            }
            character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
}

/**
 * 添加變身附加效果
 * @param {SQRCharacter} character - 角色對象
 */
function addAppendAppendage_priest_metamorphosis(character)
{
    character = sq_GetCNRDObjectToSQRCharacter(character);
    if(!character) return;
    
    local skillLevel = sq_GetSkillLevel(character, 139);
    local appendage = CNSquirrelAppendage.sq_AppendAppendage(character, character, 139, false, "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut", false);
    appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, ENUM_CHARACTERJOB_PRIEST, 139, skillLevel);
    CNSquirrelAppendage.sq_AppendAppendageID(appendage, character, character, 139, false);
    
    local changeStatus = appendage.sq_getChangeStatus("changeStatus");
    if(!changeStatus)
        changeStatus = appendage.sq_AddChangeStatusAppendageID(character, character, 0, CHANGE_STATUS_TYPE_PHYSICAL_ATTACK_BONUS, false, 0, APID_COMMON);
    
    if(changeStatus)
    {
        local attackBonus = (sq_GetLevelData(character, 139, 0, skillLevel)).tofloat();
        changeStatus.clearParameter();
        changeStatus.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_ATTACK_BONUS, true, attackBonus);
        changeStatus.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK_BONUS, true, attackBonus);
        changeStatus.addParameter(CHANGE_STATUS_TYPE_ATTACK_SPEED, false, (sq_GetLevelData(character, 139, 4, skillLevel)).tofloat());
        changeStatus.addParameter(CHANGE_STATUS_TYPE_MOVE_SPEED, false, (sq_GetLevelData(character, 139, 5, skillLevel)).tofloat());
    }
}

// ---------------------codeEnd---------------------//