package RobotGame 
{
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{
		[Embed(source = '../resources/roball.png')] private var sprChar:Class;
		[Embed(source = '../resources/roball2.png')] private var sprChar2:Class;
		[Embed(source = '../resources/roball3.png')] private var sprChar3:Class;
		[Embed(source = '../resources/roball4.png')] private var sprChar4:Class;
		private var charSprites:Array = [sprChar, sprChar2, sprChar3, sprChar4];
		[Embed(source = '../resources/p1sel.png')] private var sprP1sel:Class;
		[Embed(source = '../resources/p2sel.png')] private var sprP2sel:Class;
		[Embed(source = '../resources/Robo_Bkgrd.png')] private var sprBG:Class;
		private var characterChoices:FlxGroup;
		private var p1sel:FlxSprite, p2sel:FlxSprite;
		public function MenuState() 
		{
			super();
			add(new FlxSprite(0, 0, sprBG));
			add(characterChoices = new FlxGroup());
			for (var i:uint = 0; i < 4; ++i) {
				var newSprite:FlxSprite = FlxSprite(characterChoices.add(new FlxSprite((i + 1) * (FlxG.width/5) - 24, 64)));
				newSprite.loadGraphic(charSprites[i], true, false, 49, 49);
				newSprite.addAnimation("Run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 30, true);
				newSprite.play("Run");
			}
			add(p1sel = new FlxSprite(0, 0, sprP1sel));
			add(p2sel = new FlxSprite(0, 0, sprP2sel));
		}
		
		override public function update():void {
			super.update();
			if (FlxG.keys.justPressed("LEFT")) {
				--PlayState.p1type;
				if (PlayState.p1type < 0) PlayState.p1type += characterChoices.countLiving();
				if (PlayState.p1type == PlayState.p2type) --PlayState.p1type;
				if (PlayState.p1type < 0) PlayState.p1type += characterChoices.countLiving();
			}
			
			if (FlxG.keys.justPressed("RIGHT")) {
				++PlayState.p1type;
				if (PlayState.p1type >= characterChoices.countLiving()) PlayState.p1type -= characterChoices.countLiving();
				if (PlayState.p1type == PlayState.p2type) ++PlayState.p1type;
				if (PlayState.p1type >= characterChoices.countLiving()) PlayState.p1type -= characterChoices.countLiving();
			}
			
			if (FlxG.keys.justPressed("A")) {
				--PlayState.p2type;
				if (PlayState.p2type < 0) PlayState.p2type += characterChoices.countLiving();
				if (PlayState.p1type == PlayState.p2type) --PlayState.p2type;
				if (PlayState.p2type < 0) PlayState.p2type += characterChoices.countLiving();
			}
			
			if (FlxG.keys.justPressed("D")) {
				++PlayState.p2type;
				if (PlayState.p2type >= characterChoices.countLiving()) PlayState.p2type -= characterChoices.countLiving();
				if (PlayState.p1type == PlayState.p2type) ++PlayState.p2type;
				if (PlayState.p2type >= characterChoices.countLiving()) PlayState.p2type -= characterChoices.countLiving();
			}
			
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.switchState(new PlayState());
			}
			
			p1sel.x = FlxSprite(characterChoices.members[PlayState.p1type]).x + 8;
			p1sel.y = FlxSprite(characterChoices.members[PlayState.p1type]).y + 50;
			
			p2sel.x = FlxSprite(characterChoices.members[PlayState.p2type]).x + 8;
			p2sel.y = FlxSprite(characterChoices.members[PlayState.p2type]).y + 50;
		}
		
	}
	
}