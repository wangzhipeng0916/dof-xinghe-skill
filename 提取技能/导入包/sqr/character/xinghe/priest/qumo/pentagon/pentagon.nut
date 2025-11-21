// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行牧師五角星技能
 * @param {對象} skillUser - 技能使用者對象
 * @return {布林值} 是否可執行技能
 */
function checkExecutableSkill_priest_pentagon(skillUser)
{
    if (!skillUser) return false;
    local isSkillUsable = skillUser.sq_IsUseSkill(238);
    if (isSkillUsable)
    {
        skillUser.sq_IntVectClear();
        skillUser.sq_IntVectPush(0);
        skillUser.sq_AddSetStatePacket(238, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
};

/**
 * 檢查命令是否可用
 * @param {對象} obj - 目標對象
 * @return {布林值} 是否可用
 */
function checkCommandEnable_priest_pentagon(obj)
{
    if (!obj) return false;
    return true;
};

/**
 * 設置技能狀態
 * @param {對象} skillUser - 技能使用者對象
 * @param {整數} state - 狀態值
 * @param {數組} dataArray - 數據數組
 * @param {對象} customData - 自定義數據對象
 */
function onSetState_priest_pentagon(skillUser, state, dataArray, customData)
{
    if (!skillUser) return;
    skillUser.sq_StopMove();
    local subState = skillUser.sq_GetVectorData(dataArray, 0);
    skillUser.setSkillSubState(subState);
    switch (subState)
    {
        case 0:
            skillUser.setCurrentAnimation(skillUser.sq_GetThrowShootAni(1));
            skillUser.sq_AddStateLayerAnimation(1, skillUser.sq_CreateCNRDAnimation("effect/animation/pentagon/pentagonobject/cast/pentagoncast01.ani"), 0, 0);
            skillUser.sq_SetSuperArmor(6);
            skillUser.sq_PlaySound("PR_PENTAGON");
            break;
        case 1:
            skillUser.setCurrentAnimation(skillUser.sq_GetThrowShootAni(2));
            sq_AddDrawOnlyAniFromParent(skillUser, "character/priest/effect/animation/pentagon/pentagonobject/cast/pentagoncastafter.ani", 0, -1, 0);
            local skillLevel = sq_GetSkillLevel(skillUser, 238);
            local rangeData = skillUser.sq_GetLevelData(238, 0, sq_GetSkillLevel(skillUser, 238));
            local scaleFactor = rangeData.tofloat() / 340.0;
            skillUser.getVar().setFloat(0, scaleFactor);
            if (skillUser.sq_IsMyControlObject())
            {
                skillUser.sq_StartWrite();
                skillUser.sq_WriteDword(238);
                skillUser.sq_WriteDword(1);
                skillUser.sq_WriteDword(rangeData);
                skillUser.sq_WriteDword(skillUser.sq_GetLevelData(238, 1, skillLevel));
                skillUser.sq_WriteDword(skillUser.sq_GetLevelData(238, 2, skillLevel));
                skillUser.sq_WriteDword(skillUser.sq_GetBonusRateWithPassive(238, 238, 3, 1.0));
                skillUser.sq_WriteDword(skillUser.sq_GetBonusRateWithPassive(238, 238, 4, 1.0));
                skillUser.sq_SendCreatePassiveObjectPacket(24374, 0, (250.0 * scaleFactor).tointeger(), (20.0 * scaleFactor).tointeger(), 0);
            }
            break;
    }
    skillUser.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
};

/**
 * 結束技能狀態時處理
 * @param {對象} skillUser - 技能使用者對象
 * @param {整數} state - 狀態值
 */
function onEndState_priest_pentagon(skillUser, state)
{
    if (!skillUser) return;
    if (state != 238)
    {
        skillUser.sq_RemoveSuperArmor(6);
        if (skillUser.getSkillSubState() == 1)
        {
            local scaleFactor = skillUser.getVar().getFloat(0);
            local posX = skillUser.getXPos(); local posY = skillUser.getYPos(); local posZ = skillUser.getZPos();
            CreateAniRate(skillUser, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Spot/CastWorkPriestBack_01.ani", ENUM_DRAWLAYER_NORMAL, posX, posY - 1, posZ, scaleFactor, false);
            CreateAniRate(skillUser, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/Spot/CastWorkPriestFront_01.ani", ENUM_DRAWLAYER_NORMAL, posX, posY, posZ, scaleFactor, false);
            CreateAniRate(skillUser, "passiveobject/script_sqr_nut_qq506807329/priest/animation/pentagonobject/pentagon/startpentagon_08.ani", ENUM_DRAWLAYER_BOTTOM, posX, posY, posZ, scaleFactor, false);
        }
    }
};

/**
 * 當前動畫結束時處理
 * @param {對象} skillUser - 技能使用者對象
 */
function onEndCurrentAni_priest_pentagon(skillUser)
{
    if (!skillUser) return;
    if (!skillUser.sq_IsMyControlObject()) return;
    local currentSubState = skillUser.getSkillSubState();
    if (currentSubState != 1)
    {
        skillUser.sq_IntVectClear();
        skillUser.sq_IntVectPush(currentSubState + 1);
        skillUser.sq_AddSetStatePacket(238, STATE_PRIORITY_USER, true);
    }
    else
        skillUser.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
};

// ---------------------codeEnd---------------------//