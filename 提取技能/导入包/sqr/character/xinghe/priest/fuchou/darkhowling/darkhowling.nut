// ---------------------codeStart---------------------//

/**
 * 檢查是否可以執行暗黑咆哮技能
 * @param {SQRCharacter} character - 角色對象
 * @returns {boolean} - 是否可以執行技能
 */
function checkExecutableSkill_priest_darkhowling(character) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return false
    local isSkillUsed = character.sq_IsUseSkill(136)
    if (isSkillUsed) {
        character.sq_IsEnterSkillLastKeyUnits(136)
        character.sq_IntVectClear()
        if (isAvengerAwakenning(character)) character.sq_IntVectPush(3)
        else character.sq_IntVectPush(0)
        character.sq_AddSetStatePacket(136, STATE_PRIORITY_USER, true)
        return true
    }
    return false
}

/**
 * 檢查暗黑咆哮技能命令是否可用
 * @param {SQRCharacter} character - 角色對象
 * @returns {boolean} - 技能命令是否可用
 */
function checkCommandEnable_priest_darkhowling(character) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return false
    local characterState = character.sq_GetState()
    if (characterState == STATE_STAND) return true
    if (characterState == STATE_ATTACK) {
        return character.sq_IsCommandEnable(136)
    }
    return true
}

/**
 * 設置暗黑咆哮技能狀態
 * @param {SQRCharacter} character - 角色對象
 * @param {number} state - 狀態ID
 * @param {table} data - 數據表
 * @param {table} customData - 自定義數據
 */
function onSetState_priest_darkhowling(character, state, data, customData) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return
    character.sq_StopMove()
    local subState = character.sq_GetVectorData(data, 0)
    character.setSkillSubState(subState)
    switch (subState) {
        case 0:
            character.sq_SetCurrentAnimation(228)
            character.getVar().clear_vector()
            character.getVar().push_vector(2)
            if (character.sq_IsMyControlObject())
                sq_flashScreen(
                    character,
                    0,
                    0,
                    250,
                    170,
                    sq_RGB(255, 255, 255),
                    GRAPHICEFFECT_NONE,
                    ENUM_DRAWLAYER_BOTTOM
                )
            break
        case 1:
            character.sq_SetCurrentAnimation(229)
            character
                .getVar()
                .set_vector(0, character.getVar().get_vector(0) - 1)
            local gaugeCost = character.sq_GetVectorData(data, 1)
            if (gaugeCost != -1) consumeDevilGauge(character, gaugeCost)
            if (character.sq_IsMyControlObject()) {
                local skillLevel = sq_GetSkillLevel(character, 136)
                character.sq_StartWrite()
                character.sq_WriteDword(136)
                character.sq_WriteDword(1)
                character.sq_WriteDword(28)
                character.sq_WriteDword(
                    character.sq_GetBonusRateWithPassive(136, 136, 12, 1.0)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 6, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 3, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 4, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 5, skillLevel)
                )
                character.sq_WriteDword(0)
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 2, skillLevel)
                )
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0)
            }
            break
        case 2:
            character.sq_SetCurrentAnimation(230)
            break
        case 3:
            local animation = character
                .getVar()
                .GetAnimationMap(
                    "priest_avenger_darkhowlingawakeningcast",
                    "character/priest/animation/avengerawakening/darkhowlingawakeningcast.ani"
                )
            character.setCurrentAnimation(animation)
            character.getVar().clear_vector()
            character
                .getVar()
                .push_vector(
                    2 +
                        character.sq_GetLevelData(
                            136,
                            11,
                            sq_GetSkillLevel(character, 136)
                        )
                )
            sq_SetCustomDamageType(character, true, 1)
            break
        case 4:
            local animation = character
                .getVar()
                .GetAnimationMap(
                    "priest_avenger_darkhowlingawakeningloop",
                    "character/priest/animation/avengerawakening/darkhowlingawakeningloop.ani"
                )
            character.setCurrentAnimation(animation)
            if (character.sq_GetVectorData(data, 1) == 1) {
                if (character.sq_IsMyControlObject())
                    sq_flashScreen(
                        character,
                        0,
                        0,
                        250,
                        170,
                        sq_RGB(255, 255, 255),
                        GRAPHICEFFECT_NONE,
                        ENUM_DRAWLAYER_BOTTOM
                    )
                local shockwaveObject = sq_CreateDrawOnlyObject(
                    character,
                    "character/priest/effect/animation/darkhowling/shockwave_cast_dh2_shockwave_normal.ani",
                    ENUM_DRAWLAYER_NORMAL,
                    false
                )
                sq_moveWithParent(character, shockwaveObject)
                character.getVar("aniobj").clear_obj_vector()
                character.getVar("aniobj").push_obj_vector(shockwaveObject)
                character.sq_PlaySound("PR_DGUARDIAN_DARKHOWLING")
            }
            local gaugeCost = character.sq_GetVectorData(data, 2)
            if (gaugeCost != -1) consumeDevilGauge(character, gaugeCost)
            character
                .getVar()
                .set_vector(0, character.getVar().get_vector(0) - 1)
            if (character.sq_IsMyControlObject()) {
                local skillLevel = sq_GetSkillLevel(character, 136)
                character.sq_StartWrite()
                character.sq_WriteDword(136)
                character.sq_WriteDword(3)
                if (character.getVar().get_vector(0) > 1)
                    character.sq_WriteDword(
                        character.sq_GetBonusRateWithPassive(136, 136, 10, 1.0)
                    )
                else
                    character.sq_WriteDword(
                        character.sq_GetBonusRateWithPassive(136, 136, 12, 1.0)
                    )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 6, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 3, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 4, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 5, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 2, skillLevel)
                )
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0)
            }
            break
        case 5:
            local animation = character
                .getVar()
                .GetAnimationMap(
                    "priest_avenger_darkhowlingawakeningend",
                    "character/priest/animation/avengerawakening/darkhowlingawakeningend.ani"
                )
            character.setCurrentAnimation(animation)
            local shockwaveObject = character.getVar("aniobj").get_obj_vector(0)
            if (shockwaveObject)
                shockwaveObject.setCurrentAnimation(
                    sq_CreateAnimation(
                        "",
                        "character/priest/effect/animation/darkhowling/shockwave_end_dh2_shockwave_normal.ani"
                    )
                )
            break
    }
    character.sq_SetStaticSpeedInfo(
        SPEED_TYPE_ATTACK_SPEED,
        SPEED_TYPE_ATTACK_SPEED,
        SPEED_VALUE_DEFAULT,
        SPEED_VALUE_DEFAULT,
        1.0,
        1.0
    )
}

/**
 * 暗黑咆哮技能處理過程
 * @param {SQRCharacter} character - 角色對象
 */
function onProc_priest_darkhowling(character) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return
    local subState = character.getSkillSubState()
    switch (subState) {
        case 4:
            local shockwaveObject = character.getVar("aniobj").get_obj_vector(0)
            if (shockwaveObject)
                if (sq_IsEnd(shockwaveObject.getCurrentAnimation()))
                    shockwaveObject.setCurrentAnimation(
                        sq_CreateAnimation(
                            "",
                            "character/priest/effect/animation/darkhowling/showckwave_loop_dh2_shockwave_normal.ani"
                        )
                    )
            break
    }

    if (
        !CNSquirrelAppendage.sq_IsAppendAppendage(
            character,
            "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut"
        )
    ) {
        local currentAnimation = character.getCurrentAnimation()
        if (!currentAnimation) return
        local stateTimer = character.sq_GetStateTimer()
        local animationDuration = currentAnimation.getDelaySum(false)
        local alphaValue = -1
        switch (subState) {
            case 0:
            case 3:
                alphaValue = sq_GetUniformVelocity(
                    0,
                    255,
                    stateTimer,
                    animationDuration
                )
                break
            case 1:
            case 4:
                alphaValue = 255
                break
            case 2:
            case 5:
                alphaValue = sq_GetUniformVelocity(
                    255,
                    0,
                    stateTimer,
                    animationDuration
                )
                break
        }
        if (alphaValue != -1) {
            local alpha = sq_ALPHA(alphaValue)
            local color = sq_RGB(0, 0, 0)
            currentAnimation.setEffectLayer(
                true,
                GRAPHICEFFECT_NONE,
                true,
                color,
                alpha,
                true,
                false
            )

            local layerCount = sq_AniLayerListSize(currentAnimation)
            for (local i = 0; i < layerCount; i++) {
                local layer = sq_getAniLayerListObject(currentAnimation, i)
                if (layer) {
                    local effectType = layer
                        .GetCurrentFrame()
                        .GetGraphicEffect()
                    if (effectType != GRAPHICEFFECT_LINEARDODGE)
                        layer.setEffectLayer(
                            true,
                            GRAPHICEFFECT_NONE,
                            true,
                            color,
                            alpha,
                            true,
                            false
                        )
                }
            }
        }
    }
}

/**
 * 暗黑咆哮技能狀態結束處理
 * @param {SQRCharacter} character - 角色對象
 * @param {number} state - 狀態ID
 */
function onEndState_priest_darkhowling(character, state) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return
    if (state != 136) {
        RemoveAllAni(character)
        sq_SetCustomDamageType(character, false, 1)
    }
}

/**
 * 暗黑咆哮技能關鍵幀標誌處理
 * @param {SQRCharacter} character - 角色對象
 * @param {number} flag - 標誌值
 * @returns {boolean} - 處理結果
 */
function onKeyFrameFlag_priest_darkhowling(character, flag) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return
    local subState = character.getSkillSubState()
    switch (subState) {
        case 0:
            if (flag == 0 && character.sq_IsMyControlObject()) {
                local skillLevel = sq_GetSkillLevel(character, 136)
                character.sq_StartWrite()
                character.sq_WriteDword(136)
                character.sq_WriteDword(1)
                character.sq_WriteDword(27)
                character.sq_WriteDword(
                    character.sq_GetBonusRateWithPassive(136, 136, 0, 1.0)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 6, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 3, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 4, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 5, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 1, skillLevel)
                )
                character.sq_WriteDword(
                    character.sq_GetLevelData(136, 2, skillLevel)
                )
                character.sq_SendCreatePassiveObjectPacket(24374, 0, 0, 0, 0)
            }
            break
    }
    return true
}

/**
 * 暗黑咆哮技能當前動畫結束處理
 * @param {SQRCharacter} character - 角色對象
 */
function onEndCurrentAni_priest_darkhowling(character) {
    character = sq_GetCNRDObjectToSQRCharacter(character)
    if (!character) return
    if (!character.sq_IsMyControlObject()) return
    local subState = character.getSkillSubState()
    switch (subState) {
        case 0:
        case 1:
            local remainingCount = character.getVar().get_vector(0)
            if (
                character.isDownSkillLastKey() &&
                remainingCount > 0 &&
                isInDevilStrikeSkill(character)
            ) {
                local skillLevel = sq_GetSkillLevel(character, 136)
                local gaugeCost = CNSquirrelAppendage.sq_IsAppendAppendage(
                    character,
                    "character/xinghe/priest/fuchou/metamorphosis/ap_metamorphosis.nut"
                )
                    ? 0
                    : character.sq_GetLevelData(136, 13, skillLevel) / 2
                local currentGauge = getDevilGauge(character)
                if (currentGauge >= gaugeCost) {
                    character.sq_IntVectClear()
                    character.sq_IntVectPush(1)
                    character.sq_IntVectPush(gaugeCost)
                    character.sq_AddSetStatePacket(
                        136,
                        STATE_PRIORITY_USER,
                        true
                    )
                    return
                } else if (character.isMessage()) sq_AddMessage(29002)
            }
            character.sq_IntVectClear()
            character.sq_IntVectPush(2)
            character.sq_AddSetStatePacket(136, STATE_PRIORITY_USER, true)
            break
        case 3:
            character.sq_IntVectClear()
            character.sq_IntVectPush(subState + 1)
            character.sq_IntVectPush(1)
            character.sq_AddSetStatePacket(136, STATE_PRIORITY_USER, true)
            break
        case 4:
            local remainingCount = character.getVar().get_vector(0)
            if (remainingCount > 2) {
                character.sq_IntVectClear()
                character.sq_IntVectPush(subState)
                character.sq_IntVectPush(0)
                character.sq_AddSetStatePacket(136, STATE_PRIORITY_USER, true)
                return
            } else if (remainingCount > 0) {
                if (
                    character.isDownSkillLastKey() &&
                    isInDevilStrikeSkill(character)
                ) {
                    local skillLevel = sq_GetSkillLevel(character, 136)
                    local gaugeCost =
                        character.sq_GetLevelData(136, 13, skillLevel) / 2
                    local currentGauge = getDevilGauge(character)
                    if (currentGauge >= gaugeCost) {
                        character.sq_IntVectClear()
                        character.sq_IntVectPush(subState)
                        character.sq_IntVectPush(0)
                        character.sq_IntVectPush(gaugeCost)
                        character.sq_AddSetStatePacket(
                            136,
                            STATE_PRIORITY_USER,
                            true
                        )
                        return
                    } else if (character.isMessage()) sq_AddMessage(29002)
                }
            }
            character.sq_IntVectClear()
            character.sq_IntVectPush(subState + 1)
            character.sq_AddSetStatePacket(136, STATE_PRIORITY_USER, true)
            break
        case 2:
        case 5:
            character.sq_AddSetStatePacket(
                STATE_STAND,
                STATE_PRIORITY_USER,
                false
            )
            break
    }
}

// ---------------------codeEnd---------------------//
