// ---------------------codeStart---------------------// 

// 作者：GCT60 QQ506807329   聲明：NUT腳本引擎 授權條款1500萬種功能，超過1000種已經完成，只要符合授權條款即可使用。包含技能、道具、怪物、NPC、NPK、地圖、動作物件、UI等所有功能，均可自由使用。

/**
 * 添加函數名稱映射
 * @param {對象} appendage - 附加效果對象
 */
function sq_AddFunctionName(appendage)
{
    appendage.sq_AddFunctionName("proc", "proc_appendage_priest_doomcrush");
    appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_priest_doomcrush");
}

/**
 * 處理祭司毀滅之錘附加效果
 * @param {對象} appendageObj - 附加效果對象
 */
function proc_appendage_priest_doomcrush(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    local sourceCharacter = sq_GetCNRDObjectToSQRCharacter(appendageObj.getSource());
    
    if (!parentObj || !sourceCharacter || sourceCharacter.getState() != 137 || sourceCharacter.getSkillSubState() == 2)
    {
        appendageObj.setValid(false);
        return;
    }
    
    sq_setCurrentAxisPos(parentObj, 0, sq_GetDistancePos(sourceCharacter.getXPos(), sq_GetDirection(sourceCharacter), 125));
    sq_setCurrentAxisPos(parentObj, 1, sourceCharacter.getYPos());
    sq_setCurrentAxisPos(parentObj, 2, sourceCharacter.getZPos() + 20);
}

/**
 * 結束祭司毀滅之錘附加效果
 * @param {對象} appendageObj - 附加效果對象
 */
function onEnd_appendage_priest_doomcrush(appendageObj)
{
    if (!appendageObj) return;
    
    local parentObj = appendageObj.getParent();
    if (!parentObj)
    {
        appendageObj.setValid(false);
        return;
    }
    
    sq_SimpleMoveToNearMovablePos(parentObj, 200);
}

// ---------------------codeEnd---------------------//