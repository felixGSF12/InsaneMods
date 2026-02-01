
local shadow = require('mods.ShaderLex.scripts.backend.DropShadowCustom')
local shaderLex = {
    enable = false;
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
function onCreatePost()
    
    if (shaderLex.enable == true) then
    shadow.brightnessBF = shaderLex.brightnessBF
    shadow.brightnessGF = shaderLex.brightnessGF
    shadow.brightnessDAD = shaderLex.brightnessDAD
    shadow.contrastBF = shaderLex.contrastBF
    shadow.contrastGF = shaderLex.contrastGF
    shadow.contrastDAD = shaderLex.contrastDAD
    shadow.hueBF = shaderLex.hueBF
    shadow.hueGF = shaderLex.hueGF
    shadow.hueDAD = shaderLex.hueDAD
    shadow.saturationBF = shaderLex.saturationBF
    shadow.saturationGF = shaderLex.saturationGF
    shadow.saturationDAD = shaderLex.saturationDAD
    shadow.distanceBF = shaderLex.distanceBF
    shadow.distanceGF = shaderLex.distanceGF
    shadow.distanceDAD = shaderLex.distanceDAD
    shadow.shadowAngleBF = shaderLex.shadowAngleBF
    shadow.shadowAngleGF = shaderLex.shadowAngleGF
    shadow.shadowAngleDAD = shaderLex.shadowAngleDAD
    shadow:onCreatePost()
    fix:onCreatePost()
    end
     runHaxeCode([[
        var bfShader:FlxRuntimeShader;
        var dadShader:FlxRuntimeShader;
        var gfShader:FlxRuntimeShader;

        function saveShader(character:String) {
            switch(character) {
                case 'boyfriend':
                    bfShader = game.boyfriend.shader;
                case 'dad':
                    dadShader = game.dad.shader;
                case 'gf':
                    gfShader = game.gf.shader;
                default:
                    return;
            }
        }

        function applyShader(character:String) {
            switch(character) {
                case 'boyfriend':
                    game.boyfriend.shader = bfShader;
                case 'dad':
                    game.dad.shader = dadShader;
                case 'gf':
                    game.gf.shader = gfShader;
                default:
                    return;
            }
        }
    ]])
end
--- @param elapsed float
---
function onUpdatePost(elapsed)
    fix:onUpdate(elapsed)
    
end
return shaderLex