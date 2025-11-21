// ---------------------codeStart---------------------// 

/**
 * 檢查是否可執行技能"神之怒"
 * @param {對象} character - 角色對象
 * @returns {布林值} - 是否可執行技能
 */
function checkExecutableSkill_priest_wrathofgod(character)
{
    if (!character) return false;
    if (character.isCarryWeapon()) return false;
    local isSkillUsable = character.sq_IsUseSkill(245);
    if (isSkillUsable)
    {
        character.sq_IntVectClear();
        character.sq_IntVectPush(0);
        character.sq_AddSetStatePacket(245, STATE_PRIORITY_USER, true);
        return true;
    }
    return false;
}

/**
 * 檢查技能命令是否可用
 * @param {對象} character - 角色對象
 * @returns {布林值} - 技能命令是否可用
 */
function checkCommandEnable_priest_wrathofgod(character)
{
    if (!character) return false;
    if (character.isCarryWeapon()) return false;
    local characterState = character.sq_GetState();
    if (characterState == STATE_STAND)
        return true;
    if (characterState == STATE_ATTACK)
    {
        return character.sq_IsCommandEnable(245);
    }
    return true;
}

/**
 * 設置技能狀態
 * @param {對象} character - 角色對象
 * @param {整數} state - 狀態
 * @param {對象} data - 數據
 * @param {對象} customData - 自定義數據
 */
function onSetState_priest_wrathofgod(character, state, data, customData)
{
    if (!character) return;
    character.sq_StopMove();
    character.sq_ZStop();
    local subState = character.sq_GetVectorData(data, 0);
    character.setSkillSubState(subState);
    switch (subState)
    {
        case 0:
            character.sq_SetCurrentAnimation(144);
            character.sq_PlaySound("PR_WRATH_GOD");
            character.getVar("move").clear_vector();
            character.getVar("atkobj").clear_obj_vector();
            character.getVar("scrollPos").clear_vector();
            character.getVar("scrollPos").setBool(0, false);
            character.getVar("subAniIndex").clear_vector();
            character.getVar("subAniIndex").push_vector(146);

            local skillLevel = sq_GetSkillLevel(character, 245);
            character.getVar().clear_vector();
            character.getVar().push_vector(character.sq_GetLevelData(245, 0, skillLevel));
            character.getVar().push_vector(character.sq_GetLevelData(245, 2, skillLevel));

            character.getVar("movePos").clear_vector();
            character.getVar("movePos").push_vector(character.getXPos());
            character.getVar("movePos").push_vector(character.getYPos());
            character.getVar("movePos").push_vector(character.getZPos());
            break;
        case 1:
            character.setCurrentAnimation(null);
            character.getVar().set_vector(1, character.getVar().get_vector(1) - 1);
            local targetObject = sq_GetObject(character, character.sq_GetVectorData(data, 1), character.sq_GetVectorData(data, 2));
            character.getVar("atkobj").push_obj_vector(targetObject);
            local targetX = character.sq_GetVectorData(data, 3);
            local targetY = character.sq_GetVectorData(data, 4);
            local randomValue = character.sq_GetVectorData(data, 5);
            local distanceOffset = character.sq_GetVectorData(data, 6);
            local scrollPosSize = character.getVar("scrollPos").size_vector();
            local startX = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(0) : character.getVar("scrollPos").get_vector(0);
            local startY = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(1) : character.getVar("scrollPos").get_vector(1);
            local direction = (startX > targetX) ? ENUM_DIRECTION_LEFT : ENUM_DIRECTION_RIGHT;

            local customAnimation = sq_GetCustomAni(character, 145);
            sq_Rewind(customAnimation);
            customAnimation.setSpeedRate(240.0);
            local drawObject = sq_CreateDrawOnlyObject(character, "passiveobject/script_sqr_nut_qq506807329/priest/animation/0.ani", ENUM_DRAWLAYER_NORMAL, true);
            drawObject.setCurrentAnimation(customAnimation);
            sq_SetCurrentDirection(drawObject, direction);
            drawObject.setCurrentPos(startX, startY, 0);

            local distanceX = sq_Abs(startX - targetX);
            local distanceY = sq_Abs(startY - targetY);
            local angle = sq_Atan2(distanceY.tofloat(), distanceX.tofloat()) * (startY < targetY ? -1.0 : 1.0);
            local speed = 600;
            local effectPath = (randomValue < 50)
                ? "character/priest/effect/animation/wrathofgod/moveline_b.ani"
                : "character/priest/effect/animation/wrathofgod/moveline_a.ani";
            local scale = sq_GetDistance(startX, startY, targetX, targetY, true) / speed.tofloat();
            local effectObject = sq_CreateDrawOnlyObject(character, effectPath, ENUM_DRAWLAYER_NORMAL, true);
            local effectAnimation = effectObject.getCurrentAnimation();
            effectAnimation.setImageRateFromOriginal(scale, scale);
            sq_SetCustomRotate(effectObject, angle);
            sq_SetCurrentDirection(effectObject, direction);
            effectObject.setCurrentPos(startX, startY, 50);
            local nextAnimationIndex = character.getVar("subAniIndex").get_vector(0) + 1;
            if (nextAnimationIndex > 153)
                nextAnimationIndex = 146;
            character.getVar("subAniIndex").set_vector(0, nextAnimationIndex);
            local scrollX = sq_GetDistancePos(targetX, direction, distanceOffset);
            character.getVar("scrollPos").setBool(0, false);
            if (character.getVar("scrollPos").size_vector() > 0)
            {
                character.getVar("movePos").set_vector(0, character.getVar("scrollPos").get_vector(0));
                character.getVar("movePos").set_vector(1, character.getVar("scrollPos").get_vector(1));
            }
            character.getVar("scrollPos").clear_vector();
            character.getVar("scrollPos").push_vector(scrollX);
            character.getVar("scrollPos").push_vector(targetY);
            character.sq_PlaySound("R_WRATH_GOD_MOVE");
            if (character.sq_IsMyControlObject())
            {
                character.sq_StartWrite();
                character.sq_WriteDword(245);
                character.sq_WriteDword(1);
                character.sq_WriteDword(nextAnimationIndex);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(245, 245, 1, 1.0));
                character.sq_WriteDword(sq_GetOppositeDirection(direction));
                sq_SendCreatePassiveObjectPacketPos(character, 24374, 0, scrollX, targetY, 0);
            }
            break;
        case 2:
            local offsetX = character.sq_GetVectorData(data, 4);
            local targetX = character.sq_GetVectorData(data, 1);
            local targetY = character.sq_GetVectorData(data, 2);

            sq_MoveToNearMovablePos(character,
                targetX, targetY, 0,
                targetX, targetY, 0,
                200, -1, 5);
            character.setDirection(character.sq_GetVectorData(data, 3));
            character.sq_SetCurrentAnimation(161);
            local currentX = character.getXPos();
            local currentY = character.getYPos();
            character.getVar("move").clear_vector();
            character.getVar("move").push_vector(currentX);
            character.getVar("move").push_vector(currentY);
            character.sq_PlaySound("WRATH_GOD_MOVE_06");
            local attackObjects = character.getVar("atkobj");
            local objectCount = attackObjects.get_obj_vector_size();
            for (local i = 0; i < objectCount; i++)
            {
                local targetObj = attackObjects.get_obj_vector(i);
                if (sq_IsGrabable(character, targetObj)
                    && sq_IsHoldable(character, targetObj)
                    && !sq_IsFixture(targetObj)
                    && !CNSquirrelAppendage.sq_IsAppendAppendage(targetObj, "character/xinghe/priest/lanquan/wrathofgod/ap_wrathofgod.nut"))
                {
                    local activeObject = sq_GetCNRDObjectToActiveObject(targetObj);
                    if (!activeObject.isDead())
                    {
                        local objX = activeObject.getXPos();
                        local objY = activeObject.getYPos();
                        local objZ = activeObject.getZPos();
                        if (sq_Abs(targetX - objX) > 50
                            || sq_Abs(targetY - objY) > 20)
                        {
                            local appendage = CNSquirrelAppendage.sq_AppendAppendage(activeObject, character, 245, true, "character/xinghe/priest/lanquan/wrathofgod/ap_wrathofgod.nut", true);
                            sq_HoldAndDelayDie(activeObject, character, true, true, false, 0, 0, ENUM_DIRECTION_NEUTRAL, appendage);
                            appendage.getVar().clear_vector();
                            appendage.getVar().push_vector(objX);
                            appendage.getVar().push_vector(objY);
                            appendage.getVar().push_vector(objZ);
                            appendage.getVar().push_vector(currentX + offsetX);
                            appendage.getVar().push_vector(currentY);
                        }
                    }
                }
            }
            if (character.sq_IsMyControlObject())
            {
                character.sq_StartWrite();
                character.sq_WriteDword(245);
                character.sq_WriteDword(2);
                character.sq_WriteDword(character.sq_GetBonusRateWithPassive(245, 245, 3, 1.0));
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
                if (objectCount > 0)
                {
                    character.sq_StartWrite();
                    character.sq_WriteDword(245);
                    character.sq_WriteDword(4);
                    character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0);
                }
            }
            break;
        case 3:
            character.setDirection(sq_GetOppositeDirection(character.getDirection()));
            character.sq_SetCurrentAnimation(160);
            character.sq_SetCurrentAttackInfo(111);
            character.sq_SetCurrentAttackBonusRate(character.sq_GetBonusRateWithPassive(245, 245, 3, 1.0));
            character.getVar("move").clear_vector();
            break;
    }
    switch (subState)
    {
        case 0:
        case 2:
            character.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
            break;
    }
}

/**
 * 獲取滾動基準位置
 * @param {對象} character - 角色對象
 * @returns {布林值} - 是否成功處理
 */
function getScrollBasisPos_priest_wrathofgod(character)
{
    if (!character) return;
    if (!character.sq_IsMyControlObject()) return;
    local subState = character.getSkillSubState();
    if (subState == 1)
    {
        if (character.getVar("scrollPos").size_vector() > 0 && character.getVar("scrollPos").getBool(0) == false)
        {
            local scrollVar = character.getVar("scrollPos");
            local timer = character.sq_GetStateTimer();
            local duration = 150;
            new scrollX = sq_GetUniformVelocity(character.getVar("movePos").get_vector(0), character.getVar("scrollPos").get_vector(0), timer, duration);
            local scrollY = sq_GetUniformVelocity(character.getVar("movePos").get_vector(1), character.getVar("scrollPos").get_vector(1), timer, duration);
            character.sq_SetCameraScrollPosition(scrollX, scrollY, 0);
            if (timer >= duration)
            {
                character.getVar("scrollPos").setBool(0, true);
                local target = searchTarget_qq506807329_priest_wrathofgod(character);
                if (target == null || character.getVar().get_vector(1) <= 0)
                {
                    searchTargetEnd_qq506807329_priest_wrathofgod(character);
                }
                else
                {
                    character.sq_IntVectClear();
                    character.sq_IntVectPush(subState);
                    character.sq_IntVectPush(sq_GetGroup(target));
                    character.sq_IntVectPush(sq_GetUniqueId(target));
                    character.sq_IntVectPush(target.getXPos());
                    character.sq_IntVectPush(target.getYPos());
                    character.sq_IntVectPush(sq_getRandom(0, 100));
                    character.sq_IntVectPush(sq_getRandom(45, 85));
                    character.sq_AddSetStatePacket(245, STATE_PRIORITY_USER, true);
                }
            }
            return true;
        }
    }
    return false;
}

/**
 * 處理關鍵幀標誌
 * @param {對象} character - 角色對象
 * @param {整數} flag - 標誌值
 * @returns {布林值} - 是否成功處理
 */
function onKeyFrameFlag_priest_wrathofgod(character, flag)
{
    if (!character) return;
    local subState = character.getSkillSubState();
    switch (subState)
    {
        case 0:
            switch (flag)
            {
                case 1:
                    character.getVar("move").clear_vector();
                    character.getVar("move").push_vector(character.getZPos());
                    character.getVar("move").push_vector(110);
                    character.getVar("move").push_vector(0);
                    character.getVar("move").push_vector(7);
                    character.getVar("move").push_vector(8);
                    character.getVar("move").push_vector(12);
                    if (character.sq_IsMyControlObject())
                        sq_flashScreen(character, 250, 200, 200, 178, sq_RGB(0, 0, 0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                    break;
                case 2:
                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/wrathofgod/ready/firstatk_body_eff_back_b.ani", -27, -1, 78);
                    break;
                case 3:
                    character.getVar("move").clear_vector();
                    character.getVar("move").push_vector(character.getZPos());
                    character.getVar("move").push_vector(0);
                    character.getVar("move").push_vector(0);
                    character.getVar("move").push_vector(12);
                    character.getVar("move").push_vector(13);
                    character.getVar("move").push_vector(14);
                    break;
                case 4:
                    sq_SetMyShake(character, 3, 160);
                    if (character.sq_IsMyControlObject())
                        sq_flashScreen(character, 40, 40, 240, 255, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
                    break;
            }
            break;
        case 3:
            switch (flag)
            {
                case 1:
                    character.getVar("move").clear_vector();
                    character.getVar("move").push_vector(character.getXPos());
                    break;
                case 2:
                    sq_SetMyShake(character, 10, 800);
                    if (character.sq_IsMyControlObject())
                        sq_flashScreen(character, 50, 100, 200, 204, sq_RGB(255, 255, 255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);

                    sq_setCurrentAxisPos(sq_CreateDrawOnlyObject(character, "character/priest/effect/animation/wrathofgod/finish/finishatkeffadd_crash.ani", ENUM_DRAWLAYER_BOTTOM, true), 0, sq_GetDistancePos(character.getXPos(), character.getDirection(), 90));

                    sq_AddDrawOnlyAniFromParent(character, "character/priest/effect/animation/wrathofgod/finish/finishatkeffadd_smoke_a.ani", 97, 0, 3);
                    break;
                case 3:
                    if (character.sq_IsMyControlObject())
                    {
                        character.sq_StartWrite();
                        character.sq_WriteDword(245);
                        character.sq_WriteDword(3);
                        character.sq_WriteDword(character.sq_GetBonusRateWithPassive(245, 245, 4, 1.0));
                        character.sq_SendCreatePassiveObjectPacket(24374, 0, 94, 0, 72);
                    }
                    character.sq_PlaySound("PR_WRATH_GOD_FIN");
                    break;
            }
            break;
    }
    return true;
}

/**
 * 處理技能過程
 * @param {對象} character - 角色對象
 */
function onProc_priest_wrathofgod(character)
{
    if (!character) return;
    local subState = character.getSkillSubState();
    switch (subState)
    {
        case 0:
            if (character.getVar("move").size_vector() > 0)
            {
                local moveVar = character.getVar("move");
                local currentAnimation = character.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnimation) - currentAnimation.getDelaySum(moveVar.get_vector(2), moveVar.get_vector(3));
                local totalTime = currentAnimation.getDelaySum(moveVar.get_vector(4), moveVar.get_vector(5));
                local newZ = sq_GetAccel(moveVar.get_vector(0), moveVar.get_vector(1), currentTime, totalTime, true);
                sq_setCurrentAxisPos(character, 2, newZ);
            }
            break;
        case 2:
            local currentAnimation = character.getCurrentAnimation();
            local currentTime = sq_GetCurrentTime(currentAnimation);
            local totalTime = currentAnimation.getDelaySum(false);
            local startX = character.getVar("move").get_vector(0);
            if (startX != 0)
            {
                local newX = sq_GetDistancePos(startX,
                    character.getDirection(),
                    sq_GetUniformVelocity(0, 130, currentTime, totalTime));
                if (character.isMovablePos(newX, character.getYPos()))
                    sq_setCurrentAxisPos(character, 0, newX);
                else
                    character.getVar("move").set_vector(0, 0);
            }
            local startY = character.getVar("move").get_vector(1);
            if (startY != 0)
            {
                local newY = (startY - 20 * sq_SinTable(sq_GetUniformVelocity(0, 180, currentTime, totalTime))).tointeger();
                if (character.isMovablePos(character.getXPos(), newY))
                    sq_setCurrentAxisPos(character, 1, newY);
                else
                    character.getVar("move").set_vector(1, 0);
            }
            break;
        case 3:
            if (character.getVar("move").size_vector() > 0)
            {
                local moveVar = character.getVar("move");
                local currentAnimation = character.getCurrentAnimation();
                local currentTime = sq_GetCurrentTime(currentAnimation) - currentAnimation.getDelaySum(0, 1);
                local totalTime = currentAnimation.getDelaySum(2, 2);
                local newX = sq_GetDistancePos(moveVar.get_vector(0),
                    character.getDirection(),
                    sq_GetUniformVelocity(0, 10, currentTime, totalTime));
                if (character.isMovablePos(newX, character.getYPos()))
                    sq_setCurrentAxisPos(character, 0, newX);
                else
                    character.getVar("move").clear_vector();
            }
            break;
    }
}

/**
 * 處理當前動畫結束
 * @param {對象} character - 角色對象
 */
function onEndCurrentAni_priest_wrathofgod(character)
{
    if (!character) return;
    if (!character.sq_IsMyControlObject()) return;
    local subState = character.getSkillSubState();
    switch (subState)
    {
        case 0:
            local target = searchTarget_qq506807329_priest_wrathofgod(character);
            if (target == null)
            {
                searchTargetEnd_qq506807329_priest_wrathofgod(character);
            }
            else
            {
                character.sq_IntVectClear();
                character.sq_IntVectPush(subState + 1);
                character.sq_IntVectPush(sq_GetGroup(target));
                character.sq_IntVectPush(sq_GetUniqueId(target));
                character.sq_IntVectPush(target.getXPos());
                character.sq_IntVectPush(target.getYPos());
                character.sq_IntVectPush(sq_getRandom(0, 100));
                character.sq_IntVectPush(sq_getRandom(20, 100));
                character.sq_AddSetStatePacket(245, STATE_PRIORITY_USER, true);
            }
            break;
        case 2:
            character.sq_IntVectClear();
            character.sq_IntVectPush(subState + 1);
            character.sq_AddSetStatePacket(245, STATE_PRIORITY_USER, true);
            break;
        case 3:
            character.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
            break;
    }
}

/**
 * 搜索目標
 * @param {對象} character - 角色對象
 * @returns {對象} - 目標對象
 */
function searchTarget_qq506807329_priest_wrathofgod(character)
{
    if (!character) return;
    local searchRange = character.getVar().get_vector(0);
    local scrollPosSize = character.getVar("scrollPos").size_vector();
    local startX = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(0) : character.getVar("scrollPos").get_vector(0);
    local startY = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(1) : character.getVar("scrollPos").get_vector(1);
    local attackObjects = character.getVar("atkobj");
    local foundTarget = null;

    local objectManager = character.getObjectManager();
    local objectCount = objectManager.getCollisionObjectNumber();
    for (local i = 0; i < objectCount; i++)
    {
        local collisionObject = objectManager.getCollisionObject(i);
        if (!collisionObject
            || !character.isEnemy(collisionObject)
            || !collisionObject.isObjectType(OBJECTTYPE_ACTIVE)
            || !collisionObject.isInDamagableState(character)) continue;
        local activeObject = sq_GetCNRDObjectToActiveObject(collisionObject);
        if (!activeObject.isDead())
        {
            if (sq_GetDistance(startX, startY, activeObject.getXPos(), activeObject.getYPos(), true) <= searchRange
                && !attackObjects.is_obj_vector(collisionObject))
            {
                foundTarget = activeObject;
                break;
            }
        }
    }
    if (foundTarget == null && attackObjects.get_obj_vector_size() > 0)
        for (local i = 0; i < attackObjects.get_obj_vector_size(); i++)
        {
            local activeObject = sq_GetCNRDObjectToActiveObject(attackObjects.get_obj_vector(sq_getRandom(0, attackObjects.get_obj_vector_size() - 1)));
            if (!activeObject.isDead())
            {
                foundTarget = activeObject;
                break;
            }
        }
    return foundTarget;
}

/**
 * 結束目標搜索
 * @param {對象} character - 角色對象
 */
function searchTargetEnd_qq506807329_priest_wrathofgod(character)
{
    if (!character) return;
    local scrollPosSize = character.getVar("scrollPos").size_vector();
    local targetX = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(0) : character.getVar("scrollPos").get_vector(0);
    local targetY = (scrollPosSize <= 0) ? character.getVar("movePos").get_vector(1) : character.getVar("scrollPos").get_vector(1);
    local direction = ENUM_DIRECTION_LEFT;
    local attackObjects = character.getVar("atkobj");
    local objectCount = attackObjects.get_obj_vector_size();
    if (objectCount > 0)
    {
        local randomObject = attackObjects.get_obj_vector(sq_getRandom(0, objectCount - 1));
        while (attackObjects.get_obj_vector_size() > 0 && !randomObject)
            randomObject = attackObjects.get_obj_vector(sq_getRandom(0, attackObjects.get_obj_vector_size() - 1));
        if (targetX < randomObject.getXPos()) direction = ENUM_DIRECTION_RIGHT;
        targetX = randomObject.getXPos();
        targetY = randomObject.getYPos();
    }
    character.sq_IntVectClear();
    character.sq_IntVectPush(2);
    character.sq_IntVectPush(targetX);
    character.sq_IntVectPush(targetY);
    character.sq_IntVectPush(direction);
    character.sq_IntVectPush(sq_getRandom(-70, 70));
    character.sq_AddSetStatePacket(245, STATE_PRIORITY_USER, true);
}

// ---------------------codeEnd---------------------//