package;

import flixel.FlxG;
import flixel.FlxState;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {
    /**
	 * Function that is called up when to state is created to set it up. 
	 */

    private var _spr:FlxSSPlayer;
    private var _spr2:FlxSSPlayer;
    private var _spr3:FlxSSPlayer;
    private var _spr4:FlxSSPlayer;
    private var _tex:SSTexturePackerData;

    override public function create():Void {
        super.create();
//        var anim = "assets/images/NewAnimation_anime_1.json";
//        var png = "assets/images/20110821_tile_char.png";
//        var anim = "Player";
        var ss = "assets/images/antarctic3_anime_1.json";
        var png = "assets/images/antarctic.png";
        var anim = 0;
        _tex = new SSTexturePackerData(ss, png);
        _tex.dump();
        _spr = new FlxSSPlayer(20, 20, ss, _tex, anim);
        this.add(_spr);
        _spr.play();

        _spr2 = new FlxSSPlayer(20, 20, ss, _tex, 1);
        this.add(_spr2);
        _spr2.play();
        _spr3 = new FlxSSPlayer(20, 20, ss, _tex, 2);
        this.add(_spr3);
        _spr3.play();
        _spr4 = new FlxSSPlayer(20, 20, ss, _tex, 3);
        this.add(_spr4);
        _spr4.play();

        FlxG.debugger.toggleKeys = ["ALT"];
    }

    /**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
    override public function destroy():Void {
        super.destroy();
    }

    /**
	 * Function that is called once every frame.
	 */
    override public function update():Void {
        super.update();

        if(FlxG.mouse.justPressed) {
            _spr.play(1);
        }

        if(FlxG.keys.justPressed.D) {
            _spr.toggle();
        }
        if(FlxG.keys.justPressed.R) {
//            _spr.resetAnimation();
            FlxG.resetState();
        }
    }
}