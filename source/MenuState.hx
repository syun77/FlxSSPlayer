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

    override public function create():Void {
        super.create();
        _spr = new FlxSSPlayer(20, 20, "assets/images/NewAnimation_anime_1.json", "assets/images/20110821_tile_char.png", "Player");
        this.add(_spr);
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
            _spr.init();
        }
    }
}