// ---------------------codeStart---------------------// 

/**
 * 獲取團隊中非敵對角色的ID數組
 * @param {對象} obj - 當前對象
 * @return {數組} 團隊角色ID數組
 */
function useRangeBuff_getTeamCount(obj)
{
    local teamArray = [];
    local objectManager = obj.getObjectManager();
    for(local i = 0; i < objectManager.getCollisionObjectNumber(); i += 1)
    {
        local collisionObject = objectManager.getCollisionObject(i);
        if(collisionObject && !obj.isEnemy(collisionObject) && collisionObject.isObjectType(OBJECTTYPE_CHARACTER))
        {
            local sqrCharacter = sq_GetCNRDObjectToSQRCharacter(collisionObject);
            local isAI = sq_IsAiCharacter(sqrCharacter);
            if(isAI) continue;
            local objectId = sq_GetObjectId(collisionObject);
            teamArray.push(objectId);
        }
    }
    return teamArray;
}

/**
 * 設置範圍增益狀態
 * @param {對象} obj - 當前對象
 * @param {整數} state - 狀態值
 * @param {數據} datas - 狀態數據
 */
function useRangeBuff_setState(obj, state, datas)
{
    if(state != 13) return;
    local subState = obj.sq_GetVectorData(datas, 0);
    if(subState != 2) return;
    local skillIndex = obj.getCurrentSkillIndex();
    obj.getVar("rangeBuff").setBool(0, true);
    obj.getVar("rangeBuff").clear_vector();
    obj.getVar("rangeBuff").push_vector(0);
}

/**
 * 應用範圍增益效果
 * @param {對象} obj - 當前對象
 */
function useRangeBuff(obj)
{
    local teamArray = useRangeBuff_getTeamCount(obj);
    if(obj.getVar("rangeBuff").getBool(0))
    {
        local currentIndex = obj.getVar("rangeBuff").get_vector(0);
        if(currentIndex >= teamArray.len())
        {
            obj.getVar("rangeBuff").setBool(0, false);
            return;
        }
        obj.sq_IntVectClear();
        obj.sq_IntVectPush(1);
        obj.sq_IntVectPush(teamArray[currentIndex]);
        obj.sq_AddSetStatePacket(13, STATE_PRIORITY_IGNORE_FORCE, true);
        obj.getVar("rangeBuff").set_vector(0, currentIndex + 1);
    }
}

// ---------------------codeEnd---------------------//