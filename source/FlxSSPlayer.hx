package ;

import flixel.util.FlxAngle;
import haxe.Json;
import flixel.FlxSprite;
import openfl.Assets;

class SSAnimation {
    private static inline var IDX_PART_NO = 0;
    private static inline var IDX_IMAGE_NO = 1;
    private static inline var IDX_SOURCE_X = 2;
    private static inline var IDX_SOURCE_Y = 3;
    private static inline var IDX_SOURCE_W = 4;
    private static inline var IDX_SOURCE_H = 5;
    private static inline var IDX_DST_X = 6;
    private static inline var IDX_DST_Y = 7;
    private static inline var IDX_DST_ANGLE = 8;
    private static inline var IDX_DST_SCALE_X = 9;
    private static inline var IDX_DST_SCALE_Y = 10;
    private static inline var IDX_ORIGIN_X = 11;
    private static inline var IDX_ORIGIN_Y = 12;
    private static inline var IDX_FLIP_H = 13;
    private static inline var IDX_FLIP_V = 14;
    private static inline var IDX_ALPHA = 15;
    private static inline var IDX_V0_X = 16;
    private static inline var IDX_V0_Y = 17;

    public var x(get, null):Float;
    public var y(get, null):Float;
    public var angle(get, null):Float;
    public var scaleX(get, null):Float;
    public var scaleY(get, null):Float;
    public var originX(get, null):Float;
    public var originY(get, null):Float;
    public var flipH(get, null):Bool;
    public var flipV(get, null):Bool;
    public var alpha(get, null):Float;

    private var _data:Dynamic;
    private var _now:Int = 0;
    private var _no:Int = 0;
    public function new(data:Dynamic) {
        _data = data;
    }
    public function frameMax():Int {
        return _data.length;
    }
    public function setNo(no:Int):Void {
        _no = no;
    }
    public function setNow(frame:Int):Void {
        _now = frame;
    }
    public function getData(frame:Int=-1):Dynamic {
        if(frame < 0) {
            frame = _now;
        }
        return _data[frame][_no];
    }
    public function getDataValue(frame:Int=-1, idx:Int) {
        var data = getData(frame);

        if(idx >= cast(data).length) {
            // データが存在しない
            return 0;
        }
        return data[idx];
    }
    public function hasDataValue(frame:Int=-1, idx:Int):Bool {
        var data = getData(frame);

        if(idx >= cast(data).length) {
            // データが存在しない
            return false;
        }

        return true;
    }

    private function get_x():Float {
        return cast getDataValue(-1, IDX_DST_X);
    }
    private function get_y():Float {
        return cast getDataValue(-1, IDX_DST_Y);
    }
    private function get_angle():Float {
        return cast getDataValue(-1, IDX_DST_ANGLE);
    }
    private function get_scaleX():Float {
        return cast getDataValue(-1, IDX_DST_SCALE_X);
    }
    private function get_scaleY():Float {
        return cast getDataValue(-1, IDX_DST_SCALE_Y);
    }
    private function get_originX():Float {
        return cast getDataValue(-1, IDX_ORIGIN_X);
    }
    private function get_originY():Float {
        return cast getDataValue(-1, IDX_ORIGIN_Y);
    }
    private function get_flipH():Bool {
        if(cast getDataValue(-1, IDX_FLIP_H)) {
            return true;
        }
        else {
            return false;
        }
    }
    private function get_flipV():Bool {
        if(cast getDataValue(-1, IDX_FLIP_V)) {
            return true;
        }
        else {
            return false;
        }
    }
    private function get_alpha():Float {
        if(hasDataValue(-1, IDX_ALPHA) == false) {
            // データなし
            return 1;
        }
        return cast getDataValue(-1, IDX_ALPHA);
    }
}

class FlxSSPlayer extends FlxSprite {

    private var _ofsX:Float;
    private var _ofsY:Float;

    private var _tex:SSTexturePackerData;
    private var _animation:SSAnimation = null;
    private var _frame:Int = 0;
    private var _frameMax:Int = 0;

    public function new(X:Float, Y:Float, Description:String, AssetName:String, FrameName:String) {
        super();
        setDrawOffset(X, Y);
        _tex = new SSTexturePackerData(Description, AssetName);

        loadGraphicFromTexture(_tex, false, FrameName);

        loadAnimation(Description);

    }

    public function setDrawOffset(X:Float, Y:Float):Void {
        _ofsX = X;
        _ofsY = Y;
    }

    public function loadAnimation(Animation:String):Void {
        var data = Json.parse(openfl.Assets.getText(Animation));

        var anim = data[0].animation;
        var ssa = anim.ssa;

        // アニメーション配列を格納
        _animation = new SSAnimation(ssa);
        _animation.setNo(0);

        _frame = 0;
        _frameMax = _animation.frameMax();
    }

    override public function update():Void {
        _animation.setNow(_frame);

        // アニメーションパラメータ反映
        x = _ofsX + _animation.x;
        y = _ofsY + _animation.y;
        angle = _animation.angle * FlxAngle.TO_DEG;
        scale.set(_animation.scaleX, _animation.scaleY);
        flipX = _animation.flipH;
        flipY = _animation.flipV;
        alpha = _animation.alpha;

        _frame++;
        if(_frame >= _frameMax) {
            _frame = 0;
        }

        super.update();
    }
}

