-- Shadow colors (RGB Normalized)

local DropShadowCustom = {
    shadowColorBF = {1, 1, 1},
    shadowColorGF = {1, 1, 1},
    shadowColorDAD = {1, 1, 1},

    hueBF = -46,
    saturationBF = -20,
    contrastBF = -25,
    brightnessBF = -46,

    hueGF = -46,
    saturationGF = -20,
    contrastGF = -25,
    brightnessGF = -46,

    hueDAD = -46,
    saturationDAD = -20,
    contrastDAD = -25,
    brightnessDAD = -46,

    distanceBF = 15,
    distanceGF = 15,
    distanceDAD = 15,

    shadowAngleBF = 75,
    shadowAngleGF = 75,
    shadowAngleDAD = 135
}

-- LISTA GF SPECIAL
local gfAdjustFirstList = {'nene', 'nene-christmas'}

function DropShadowCustom:isGFAdjustFirst(charName)
    for _, name in ipairs(gfAdjustFirstList) do
        if name == charName then return true end
    end
    return false
end

-----------------------------------
--          ON CREATE POST
-----------------------------------

function DropShadowCustom:onCreatePost()
    if not shadersEnabled then return end

    initLuaShader('dropShadow')
    initLuaShader('adjustColor')

    -- HAXE: Update shader per frame
    runHaxeCode([[
        import flixel.math.FlxAngle;
        function setShaderFrameInfo(objectName:String) {
            var object = switch (objectName) {
                case 'boyfriend': game.boyfriend;
                case 'dad': game.dad;
                case 'gf': game.gf;
                default: game.getLuaObject(objectName);
            }
            var originalCallback = object.animation.callback;
            object.animation.callback = function(name, frameNumber, frameIndex) {
                if (object.shader != null && object.frame != null) {
                    object.shader.setFloatArray('uFrameBounds', [
                        object.frame.uv.x, object.frame.uv.y,
                        object.frame.uv.width, object.frame.uv.height
                    ]);
                    object.shader.setFloat('angOffset', object.frame.angle * FlxAngle.TO_RAD);
                }
                if (originalCallback != null) originalCallback(name, frameNumber, frameIndex);
            }
        }
    ]])

    DropShadowCustom:applyShaderIfVisible('boyfriend',
        DropShadowCustom.hueBF, DropShadowCustom.saturationBF,
        DropShadowCustom.contrastBF, DropShadowCustom.brightnessBF,
        DropShadowCustom.shadowAngleBF, DropShadowCustom.distanceBF,
        DropShadowCustom.shadowColorBF
    )

    DropShadowCustom:applyShaderIfVisible('dad',
        DropShadowCustom.hueDAD, DropShadowCustom.saturationDAD,
        DropShadowCustom.contrastDAD, DropShadowCustom.brightnessDAD,
        DropShadowCustom.shadowAngleDAD, DropShadowCustom.distanceDAD,
        DropShadowCustom.shadowColorDAD
    )

    local gfChar = getProperty('gf.curCharacter')
    if getProperty('gf.visible') then
        if DropShadowCustom:isGFAdjustFirst(gfChar) then
            DropShadowCustom:applyAdjustColor('gf', DropShadowCustom.hueGF, DropShadowCustom.saturationGF,
                DropShadowCustom.contrastGF, DropShadowCustom.brightnessGF
            )
        else
            DropShadowCustom:applyDropShadow('gf',
                DropShadowCustom.hueGF, DropShadowCustom.saturationGF,
                DropShadowCustom.contrastGF, DropShadowCustom.brightnessGF,
                DropShadowCustom.shadowAngleGF, DropShadowCustom.distanceGF,
                DropShadowCustom.shadowColorGF
            )
        end
    end
end


-----------------------------------
--       APLICACIÓN PRINCIPAL
-----------------------------------

function DropShadowCustom:applyShaderIfVisible(name, hue, sat, cont, bright, ang, dist, col)
    if getProperty(name .. '.visible') then
        DropShadowCustom:applyDropShadow(name, hue, sat, cont, bright, ang, dist, col)
    end
end

function DropShadowCustom:applyDropShadow(object, hue, saturation, contrast, brightness, shadowAngle, distance, shadowColor)
    setSpriteShader(object, 'dropShadow')

    setShaderFloat(object, 'hue', hue)
    setShaderFloat(object, 'saturation', saturation)
    setShaderFloat(object, 'contrast', contrast)
    setShaderFloat(object, 'brightness', brightness)
    setShaderFloat(object, 'ang', math.rad(shadowAngle))
    setShaderFloat(object, 'str', 1)
    setShaderFloat(object, 'dist', distance)
    setShaderFloat(object, 'thr', 0.1)
    setShaderFloat(object, 'AA_STAGES', 2)
    setShaderFloatArray(object, 'dropColor', shadowColor)

    runHaxeFunction('setShaderFrameInfo', {object})
end

function DropShadowCustom:applyAdjustColor(object, hue, saturation, contrast, brightness)
    setSpriteShader(object, 'adjustColor')
    setShaderFloat(object, 'hue', hue)
    setShaderFloat(object, 'saturation', saturation)
    setShaderFloat(object, 'contrast', contrast)
    setShaderFloat(object, 'brightness', brightness)
end

-----------------------------------
--  FIX GF EN COUNTER / START
-----------------------------------

function onCountdownTick(swagCounter)
    if swagCounter == 1 and isGFAdjustFirst(getProperty('gf.curCharacter')) then
        DropShadowCustom:applyDropShadow('gf',
            DropShadowCustom.hueGF, DropShadowCustom.saturationGF,
            DropShadowCustom.contrastGF, DropShadowCustom.brightnessGF,
            DropShadowCustom.shadowAngleGF, DropShadowCustom.distanceGF,
            DropShadowCustom.shadowColorGF
        )
    end
end

function onSongStart()
    if shadersEnabled and DropShadowCustom:isGFAdjustFirst(getProperty('gf.curCharacter')) then
        DropShadowCustom:applyDropShadow('gf',
            DropShadowCustom.hueGF, DropShadowCustom.saturationGF,
            DropShadowCustom.contrastGF, DropShadowCustom.brightnessGF,
            DropShadowCustom.shadowAngleGF, DropShadowCustom.distanceGF,
            DropShadowCustom.shadowColorGF
        )
    end
end

return DropShadowCustom
