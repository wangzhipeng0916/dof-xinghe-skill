// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行技能 - 牧師木星技能
 * @param {object} obj - 技能施放者對象
 * @returns {boolean} 是否可以執行技能
 */
function checkExecutableSkill_priest_jupiter(obj) 
{
    if (!obj) return false;
    local isUse = obj.sq_IsUseSkill(250);
    if (isUse) 
    {
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(0);
        obj.sq_AddSetStatePacket(250, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查技能命令是否可用 - 牧師木星技能
 * @param {object} obj - 技能施放者對象
 * @returns {boolean} 技能命令是否可用
 */
function checkCommandEnable_priest_jupiter(obj) 
{
    if (!obj) return false;
    return true;
};

/**
 * 設置技能狀態 - 牧師木星技能
 * @param {object} character - 技能施放者對象
 * @param {integer} state - 技能狀態
 * @param {object} data - 技能數據
 * @param {object} skillInfo - 技能信息
 */
function onSetState_priest_jupiter(character, state, data, skillInfo)
{
    if(!character) return; 
    character.sq_StopMove(); 
    local subState = character.sq_GetVectorData(data, 0); 
    character.setSkillSubState(subState); 
    switch(subState)
    {
        case 0:
            local animation = null;
            if(CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
            {
                animation = sq_GetCustomAni(character, 180);
            }
            else
            {
                animation = character.sq_GetThrowChargeAni(2);
            }
            character.setCurrentAnimation(animation);
            sq_SetCustomDamageType(character, true, 2); 
            break;
        case 1:
            local animation = null;
            if(CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut") == true)
            {
                animation = sq_GetCustomAni(character, 184);
            }
            else
            {
                animation = character.sq_GetThrowShootAni(2);
            }
            character.setCurrentAnimation(animation);
            character.sq_PlaySound("PR_THUNDERHAMMER_01"); 
            break;
    }
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0); 
};

/**
 * 技能狀態結束處理 - 牧師木星技能
 * @param {object} character - 技能施放者對象
 * @param {integer} state - 技能狀態
 */
function onEndState_priest_jupiter(character, state)
{
    if(!character) return;
    if(state != 250)
    {
        sq_SetCustomDamageType(character, false, 2); 
    }
};

/**
 * 當前動畫結束處理 - 牧師木星技能
 * @param {object} character - 技能施放者對象
 */
function onEndCurrentAni_priest_jupiter(character)
{
    if(!character) return;
    if(!character.sq_IsMyControlObject()) return;
    local subState = character.getSkillSubState(); 
    switch(subState)
    {
        case 0:
            character.sq_IntVectClear();
            character.sq_IntVectPush(1); 
            character.sq_AddSetStatePacket(250, STATE_PRIORITY_USER, true); 
            break;
        case 1:
            if(!CNSquirrelAppendage.sq_IsAppendAppendage(character, "character/xinghe/priest/jupiter/ap_jupiter.nut")) 
            {
                sq_BinaryStartWrite();
                sq_BinaryWriteWord(1); 
                sq_SendChangeSkillEffectPacket(character, 250); 
            }
            character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false); 
            break;
    }
};

/**
 * 添加附屬效果 - 牧師木星技能
 * @param {object} character - 技能施放者對象
 */
function onAppendAppendage_priest_jupiter(character)
{
    if(!character) return;
    local appendage = CNSquirrelAppendage.sq_AppendAppendage(character, character, 250, false, "character/xinghe/priest/jupiter/ap_jupiter.nut", false); 
    local skillLevel = sq_GetSkillLevel(character, 250); 
    appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, ENUM_CHARACTERJOB_PRIEST, 250, skillLevel); 
    CNSquirrelAppendage.sq_AppendAppendageID(appendage, character, character, 250, false); 
    appendage.setEnableIsBuff(true);
    appendage.setBuffIconImage(76); 
    local statusChange = appendage.sq_getChangeStatus("changeStatus"); 
    if(!statusChange) 
    {
        statusChange = appendage.sq_AddChangeStatusAppendageID(character, character, 0, CHANGE_STATUS_TYPE_HP_MAX, false, 0, APID_COMMON);
    }
    if(statusChange) 
    {
        local defenseValue = (sq_GetLevelData(character, 250, 0, skillLevel)).tofloat(); 
        statusChange.clearParameter(); 
        statusChange.addParameter(CHANGE_STATUS_TYPE_MAGICAL_DEFENSE, true, defenseValue); 
        statusChange.addParameter(CHANGE_STATUS_TYPE_PHYSICAL_DEFENSE, true, defenseValue); 
    }
};

// ---------------------codeEnd---------------------//