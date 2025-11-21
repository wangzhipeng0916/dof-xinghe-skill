// ---------------------codeStart---------------------// 

// 原子斬擊技能處理腳本
// 技能ID: 244

/**
 * 檢查是否可以執行原子斬擊技能
 * @param {對象} character - 角色對象
 * @return {boolean} 是否可以執行技能
 */
function checkExecutableSkill_priest_atomicchopper(character)
{
    if(!character) return false; 
    if(character.isCarryWeapon()) return false; 
    local isSkillUsable = character.sq_IsUseSkill(244); 
    if(isSkillUsable) 
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0); 
        character.sq_AddSetStatePacket(244, STATE_PRIORITY_USER, true); 
        return true; 
    }
    return false; 
} 

/**
 * 檢查命令是否可用
 * @param {對象} character - 角色對象
 * @return {boolean} 命令是否可用
 */
function checkCommandEnable_priest_atomicchopper(character)
{
    if(!character) return false; 
    if(character.isCarryWeapon()) return false; 
    local characterState = character.sq_GetState(); 
    if(characterState == STATE_STAND) 
        return true; 
    if(characterState == STATE_ATTACK) 
    {
        return character.sq_IsCommandEnable(244); 
    }
    return true; 
} 

/**
 * 設置技能狀態
 * @param {對象} character - 角色對象
 * @param {整數} state - 狀態值
 * @param {對象} data - 數據對象
 * @param {對象} customData - 自定義數據
 */
function onSetState_priest_atomicchopper(character, state, data, customData)
{
    if(!character) return; 
    character.sq_StopMove(); 
    local subState = character.sq_GetVectorData(data, 0); 
    character.setSkillSubState(subState); 
    switch(subState)
    {
        case 0:
            character.sq_SetCurrentAnimation(141);
            character.getVar().clear_vector(); 
            character.getVar().push_vector(character.getXPos()); 
            character.sq_PlaySound("PR_ATOMIC_CHOPPER_01");
            break;
        case 1:
            character.sq_SetCurrentAnimation(142);
            character.sq_SetCurrentAttackInfo(107);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(244, 244, 0, 1.0)); 
            character.getVar().setBool(0, false); 
            break;
        case 2:
            character.sq_SetCurrentAnimation(143);
            character.sq_SetCurrentAttackInfo(108);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(244, 244, 1, 1.0)); 
            break;
    }
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0); 
} 

/**
 * 關鍵幀標誌處理
 * @param {對象} character - 角色對象
 * @param {整數} flag - 標誌值
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_atomicchopper(character, flag)
{
    if(!character) return false;
    local subState = character.getSkillSubState(); 
    if(subState == 2)
    {
        if(flag == 1)
        {
            character.sq_PlaySound("PR_ATOMIC_CHOPPER_02");
            sq_SetMyShake(character, 5, 240); 
            if(character.sq_IsMyControlObject())
                sq_flashScreen(character, 0, 0, 320, 255, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM); 
            if(character.getVar().getBool(0) == true)
            {
                local groundCrack = sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/atomicchopper/atomicchopper_ground_crack.ani", ENUM_DRAWLAYER_BOTTOM, true); 
                local rockEffect = sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/atomicchopper/atomicchopper_rock_rocka.ani", ENUM_DRAWLAYER_BOTTOM, true); 
                local effectPos = sq_GetDistancePos(character.getXPos(), character.getDirection(), 120); 
                sq_setCurrentAxisPos(groundCrack, 0, effectPos); 
                sq_setCurrentAxisPos(rockEffect, 0, effectPos); 
            }
        }
    }
    return true;
} 

/**
 * 攻擊處理
 * @param {對象} attacker - 攻擊者對象
 * @param {對象} target - 目標對象
 * @param {對象} attackInfo - 攻擊信息
 * @param {boolean} isCounterAttack - 是否反擊
 */
function onAttack_priest_atomicchopper(attacker, target, attackInfo, isCounterAttack)
{
    if(!attacker) return;
    if(isCounterAttack || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    local subState = attacker.getSkillSubState(); 
    switch(subState)
    {
        case 1:
        case 2:
            if(attacker.getVar().getBool(0) == false) 
                attacker.getVar().setBool(0, true);
            break;
    }
} 

/**
 * 持續處理
 * @param {對象} character - 角色對象
 */
function onProc_priest_atomicchopper(character)
{
    if(!character) return;
    local subState = character.getSkillSubState(); 
    if(subState == 0 && character.getVar().size_vector() > 0)
    {
        local currentAnim = character.getCurrentAnimation(); 
        local currentTime = sq_GetCurrentTime(currentAnim); 
        local totalTime = currentAnim.getDelaySum(false); 
        local newXPos = sq_GetDistancePos(character.getVar().get_vector(0), 
            character.getDirection(),
            sq_GetAccel(0, 30, currentTime, totalTime, true)); 
        if(character.isMovablePos(newXPos, character.getYPos()))
            sq_setCurrentAxisPos(character, 0, newXPos); 
        else
            character.getVar().clear_vector(); 
    }
} 

/**
 * 當前動畫結束處理
 * @param {對象} character - 角色對象
 */
function onEndCurrentAni_priest_atomicchopper(character)
{
    if(!character) return;
    if(!character.sq_IsMyControlObject()) return;
    local subState = character.getSkillSubState(); 
    if(subState != 2)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(subState + 1); 
        character.sq_AddSetStatePacket(244, STATE_PRIORITY_USER, true); 
    }
    else
        character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false); 
} 

// ---------------------codeEnd---------------------//