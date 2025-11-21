

// 技能：牧師 - 爆破拳
// 作者：GCT60 QQ506807329
// 說明：此技能為牧師的爆破拳技能腳本，包含技能執行檢查、狀態設置、關鍵幀處理、攻擊處理等函數。

/**
 * 檢查是否可以執行爆破拳技能
 * @param {對象} character - 角色對象
 * @return {boolean} 是否可以執行技能
 */
function checkExecutableSkill_priest_demolitionpunch(character)
{
    if (!character) return false;
    if (character.isCarryWeapon()) return false;
    local isSkillUsed = character.sq_IsUseSkill(243);
    if (isSkillUsed)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0);
        character.sq_AddSetStatePacket(243, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查爆破拳技能命令是否可用
 * @param {對象} character - 角色對象
 * @return {boolean} 技能命令是否可用
 */
function checkCommandEnable_priest_demolitionpunch(character)
{
    if (!character) return false;
    if (character.isCarryWeapon()) return false;
    local characterState = character.sq_GetState();
    if (characterState == STATE_STAND)
        return true;
    if (characterState == STATE_ATTACK)
    {
        return character.sq_IsCommandEnable(243);
    }
    return true;
}

/**
 * 設置爆破拳技能狀態
 * @param {對象} character - 角色對象
 * @param {對象} skillState - 技能狀態
 * @param {對象} skillData - 技能數據
 * @param {對象} customData - 自定義數據
 */
function onSetState_priest_demolitionpunch(character, skillState, skillData, customData)
{
    if (!character) return;
    character.sq_StopMove();
    local subState = character.sq_GetVectorData(skillData, 0);
    character.setSkillSubState(subState);
    switch (subState)
    {
        case 0:
            character.sq_SetCurrentAnimation(139);
            character.getVar().clear_vector();
            character.getVar().push_vector(character.getXPos());
            character.sq_PlaySound("PR_DEMOLITION_PUNCH");
            break;
        case 1:
            character.sq_SetCurrentAnimation(140);
            character.sq_SetCurrentAttackInfo(106);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(243, 243, 0, 1.0));
            character.getVar().setBool(0, false);
            break;
    }
    character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

/**
 * 處理關鍵幀標記
 * @param {對象} character - 角色對象
 * @param {整數} flagValue - 標記值
 * @return {boolean} 處理結果
 */
function onKeyFrameFlag_priest_demolitionpunch(character, flagValue)
{
    if (!character) return false;
    local subState = character.getSkillSubState();
    if (subState == 1)
    {
        if (flagValue == 1)
        {
            sq_SetMyShake(character, 5, 150);
            if (character.getVar().getBool(0) == true)
            {
                if (character.sq_IsMyControlObject())
                {
                    character.sq_StartWrite();
                    character.sq_WriteDword(243);
                    character.sq_WriteDword(character.sq_GetBonusRateWithPassive(243, 243, 1, 1.0));
                    character.sq_SendCreatePassiveObjectPacket(24374, 0, 111, 0, 149);
                }
            }
        }
    }
    return true;
}

/**
 * 處理攻擊事件
 * @param {對象} character - 角色對象
 * @param {對象} target - 目標對象
 * @param {對象} attackInfo - 攻擊信息
 * @param {布爾值} isCounterAttack - 是否反擊
 */
function onAttack_priest_demolitionpunch(character, target, attackInfo, isCounterAttack)
{
    if (!character) return;
    if (isCounterAttack || !target.isObjectType(OBJECTTYPE_ACTIVE)) return;
    local subState = character.getSkillSubState();
    switch (subState)
    {
        case 1:
            if (character.getVar().getBool(0) == false)
                character.getVar().setBool(0, true);
            local characterXPos = character.getXPos();
            local characterYPos = character.getYPos();
            local characterZPos = character.getZPos() + 90;
            sq_MoveToNearMovablePos(target,
                sq_GetDistancePos(characterXPos, character.getDirection(), 80), characterYPos, characterZPos,
                characterXPos, characterYPos, characterZPos,
                80, -1, 5);
            break;
    }
}

/**
 * 技能處理過程
 * @param {對象} character - 角色對象
 */
function onProc_priest_demolitionpunch(character)
{
    if (!character) return;
    local subState = character.getSkillSubState();
    if (subState == 0 && character.getVar().size_vector() > 0)
    {
        local currentAnimation = character.getCurrentAnimation();
        local currentTime = sq_GetCurrentTime(currentAnimation);
        local totalDelay = currentAnimation.getDelaySum(false);
        local newXPos = sq_GetDistancePos(character.getVar().get_vector(0),
            character.getDirection(),
            sq_GetAccel(0, 30, currentTime, totalDelay, true));
        if (character.isMovablePos(newXPos, character.getYPos()))
            sq_setCurrentAxisPos(character, 0, newXPos);
        else
            character.getVar().clear_vector();
    }
}

/**
 * 當前動畫結束處理
 * @param {對象} character - 角色對象
 */
function onEndCurrentAni_priest_demolitionpunch(character)
{
    if (!character) return;
    if (!character.sq_IsMyControlObject()) return;
    local subState = character.getSkillSubState();
    if (subState == 0)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(subState + 1);
        character.sq_AddSetStatePacket(243, STATE_PRIORITY_USER, true);
    }
    else
        character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

// ---------------------codeEnd---------------------
