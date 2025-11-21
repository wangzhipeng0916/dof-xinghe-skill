// ---------------------codeStart---------------------// 

/**
 * 檢查是否可以執行螺旋衝擊技能
 * @param {對象} obj - 技能使用者對象
 * @return {布林值} 是否成功執行技能
 */
function checkExecutableSkill_CorkscrewBlow(obj)
{
    if (!obj) return false;

    local isSkillUsed = obj.sq_IsUseSkill(SKILL_CORKSCREWBLOW);

    if (isSkillUsed)
    {
        obj.getVar("state").clear_vector();
        obj.getVar("state").push_vector(0);
        obj.sq_IsEnterSkillLastKeyUnits(SKILL_CORKSCREWBLOW);
        obj.sq_AddSetStatePacket(STATE_CORKSCREWBLOW, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查螺旋衝擊技能命令是否可用
 * @param {對象} obj - 技能使用者對象
 * @return {布林值} 總是返回真
 */
function checkCommandEnable_CorkscrewBlow(obj)
{
    return true;
}

/**
 * 設置螺旋衝擊技能狀態
 * @param {對象} obj - 技能使用者對象
 * @param {整數} state - 狀態值
 * @param {數組} datas - 附加數據
 * @param {布林值} isResetTimer - 是否重置計時器
 */
function onSetState_CorkscrewBlow(obj, state, datas, isResetTimer)
{
    local currentState = obj.getVar("state").get_vector(0);

    obj.sq_StopMove();

    if (currentState == 0)
    {
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_CORKSCREWBLOWREADY_BODY);
    }
    if (currentState == 1)
    {
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_CORKSCREWBLOWATTACKA_BODY);
        obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_CORKSCREWBLOWATTACK);

        local damageRate = obj.sq_GetBonusRateWithPassive(SKILL_CORKSCREWBLOW, STATE_CORKSCREWBLOW, 0, 1.0);
        obj.sq_SetCurrentAttackBonusRate(damageRate);
    }
    if (currentState == 2)
    {
        obj.getVar("dama").clear_obj_vector();
        obj.getVar("pull").clear_vector();
        obj.getVar("pull").push_vector(0);

        findAllMonster_CorkscrewBlow(obj);

        obj.sq_SetCurrentAnimation(CUSTOM_ANI_CORKSCREWBLOWATTACKB_BODY);
        obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_CORKSCREWBLOWATTACK);

        local damageRate = obj.sq_GetBonusRateWithPassive(SKILL_CORKSCREWBLOW, STATE_CORKSCREWBLOW, 0, 1.0);
        obj.sq_SetCurrentAttackBonusRate(damageRate);

        obj.setTimeEvent(0, 50, 0, true);
        obj.setTimeEvent(1, 300, 0, false);
    }
    if (currentState == 3)
    {
        obj.sq_SetCurrentAnimation(CUSTOM_ANI_CORKSCREWBLOWEND_BODY);
        obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_CORKSCREWBLOWFINISH);

        local damageRate = obj.sq_GetBonusRateWithPassive(SKILL_CORKSCREWBLOW, STATE_CORKSCREWBLOW, 1, 1.0);
        obj.sq_SetCurrentAttackBonusRate(damageRate);
    }
}

/**
 * 螺旋衝擊技能計時事件處理
 * @param {對象} obj - 技能使用者對象
 * @param {整數} timeEventIndex - 計時事件索引
 * @param {整數} timeEventCount - 計時事件計數
 */
function onTimeEvent_CorkscrewBlow(obj, timeEventIndex, timeEventCount)
{
    local currentState = obj.getVar("state").get_vector(0);

    if (currentState == 2)
    {
        if (timeEventIndex == 0)
        {
            if (timeEventCount <= 6)
            {
                obj.resetHitObjectList();
            }
        }
        if (timeEventIndex == 1)
        {
            obj.getVar("state").clear_vector();
            obj.getVar("state").push_vector(3);
            obj.sq_AddSetStatePacket(STATE_CORKSCREWBLOW, STATE_PRIORITY_USER, true);
        }
    }
}

/**
 * 螺旋衝擊技能處理過程
 * @param {對象} obj - 技能使用者對象
 */
function onProc_CorkscrewBlow(obj)
{
    local currentState = obj.getVar("state").get_vector(0);

    if (currentState == 2)
    {
        obj.getVar("pull").clear_vector();
        obj.getVar("pull").push_vector(1);

        local damageVar = obj.getVar("dama");
        local objectCount = damageVar.get_obj_vector_size();

        for (local i = 0; i < objectCount; ++i)
        {
            local damager = damageVar.get_obj_vector(i);
            local targetX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), obj.sq_GetIntData(SKILL_CORKSCREWBLOW, 0));
            local targetY = obj.getYPos();
            local damagerX = damager.getXPos();
            local damagerY = damager.getYPos();
            local damagerZ = damager.getZPos();
            local moveX = 2;
            local moveY = 2;
            
            if (targetX < damagerX) moveX = -moveX;
            if (targetY < damagerY) moveY = -moveY;
            
            damager.setCurrentPos(damagerX + moveX, damagerY + moveY, damagerZ);
        }
    }
}

/**
 * 尋找所有可攻擊的怪物
 * @param {對象} obj - 技能使用者對象
 */
function findAllMonster_CorkscrewBlow(obj)
{
    local currentState = obj.getVar("state").get_vector(0);

    if (currentState == 2)
    {
        local objectManager = obj.getObjectManager();

        for (local i = 0; i < objectManager.getCollisionObjectNumber(); i += 1)
        {
            local collisionObject = objectManager.getCollisionObject(i);

            if (collisionObject 
                && obj.isEnemy(collisionObject) 
                && collisionObject.isObjectType(OBJECTTYPE_ACTIVE) 
                && abs(obj.getXPos() - collisionObject.getXPos()) < 200 
                && abs(obj.getYPos() - collisionObject.getYPos()) < 150)
            {
                local activeObject = sq_GetCNRDObjectToActiveObject(collisionObject);
                obj.getVar("dama").push_obj_vector(activeObject);
            }
        }
    }
}

/**
 * 螺旋衝擊技能動畫結束處理
 * @param {對象} obj - 技能使用者對象
 */
function onEndCurrentAni_CorkscrewBlow(obj)
{
    local currentState = obj.getVar("state").get_vector(0);

    if (currentState == 0)
    {
        obj.getVar("state").clear_vector();
        obj.getVar("state").push_vector(1);
        obj.sq_AddSetStatePacket(STATE_CORKSCREWBLOW, STATE_PRIORITY_USER, true);
    }
    if (currentState == 1)
    {
        obj.getVar("state").clear_vector();
        obj.getVar("state").push_vector(2);
        obj.sq_AddSetStatePacket(STATE_CORKSCREWBLOW, STATE_PRIORITY_USER, true);
    }
    if (currentState == 3)
    {
        obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
    }
}

// ---------------------codeEnd---------------------//