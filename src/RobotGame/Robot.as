package RobotGame 
{
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*
	import flash.utils.Dictionary;
	import org.flixel.*
	public class Robot extends SolidObject
	{
		//public var canJump:Boolean
		[Embed(source = '../resources/roball.png')] private static var sprChar:Class;
		[Embed(source = '../resources/roball2.png')] private static var sprChar2:Class;
		[Embed(source = '../resources/roball3.png')] private static var sprChar3:Class;
		[Embed(source = '../resources/roball4.png')] private static var sprChar4:Class;
		private static var charSprites:Array = [sprChar, sprChar2, sprChar3, sprChar4];
		// Sounds
		//[Embed(source = '../resources/harsh_hit.mp3')] private var _snd_HarshHit:Class;
		//private var snd_HarshHit:FlxSound;
		[Embed(source = '../resources/meep_1.mp3')] private static var snd_Hit1:Class;
		[Embed(source = '../resources/meep_2.mp3')] private static var snd_Hit2:Class;
		[Embed(source = '../resources/meep_3.mp3')] private static var snd_Hit3:Class;
		[Embed(source = '../resources/meep_4.mp3')] private static var snd_Hit4:Class;
		private static var snd_Hits:Array = [snd_Hit1, snd_Hit2, snd_Hit3, snd_Hit4];
		private var snd_Hit:FlxSound;
		
		public var contactsAndDirections:Dictionary;
		public var jumpDir:b2Vec2
		public var jumpControl:String
		public var leftControl:String
		public var rightControl:String
		public var repulsionSpeed:Number = 48
		private var imageIndex:Number = 0;
		private var type:int;
		private var enemyName:String;
		
		public function Robot(World:b2World, X:Number, Y:Number, JumpControl:String, LeftControl:String, RightControl:String, Type:int, EnemyName:String) 
		{
			super(World, X, Y)
			// Controls
			jumpControl = JumpControl
			leftControl = LeftControl
			rightControl = RightControl
			// Sprite
			this.loadGraphic(charSprites[Type],true,true,49,49)
			//this.makeGraphic(96, 96)
			// Box2D
			var shape:b2CircleShape = new b2CircleShape(24.5/ratio)
			createBody(shape, b2Body.b2_dynamicBody, 0.2, 0.3, Type == 1 ? 1.05 : 0.7) // type 1 is heavier than others
			_obj.SetLinearDamping(0.1)
			_obj.SetAngularDamping(5)
			_obj.GetFixtureList().SetRestitution(0.1) // dunno? Still bouncy.
			//_obj.SetLinearDamping(0.1); // repeat - reason?
			type = Type;
			enemyName = EnemyName;
			
			// Sounds
			//snd_HarshHit = FlxG.loadSound(_snd_HarshHit, 0.5 /*volume*/, false /*don't loop*/, true /*auto destroy*/);
			snd_Hit = FlxG.loadSound(snd_Hits[type], 0.5 /*volume*/, false /*don't loop*/, true /*auto destroy*/);
		}
		override public function update():void {
			var multiplier:Number = _obj.GetMass()
			var angVelMult:Number, angOppositeMult:Number,
				airSpeedControl:Number, groundSpeedControl:Number
			if (type == 0) { //This robot is fastest
				angVelMult = 1.5;
				angOppositeMult = 1.95;
				airSpeedControl = 0.45;
				groundSpeedControl = 0.45;
			} else {
				angVelMult = 1; // holds any mults to increase angular velocity (e.g. angOppositeMult)
				angOppositeMult = 1.3; // mult to increase angular velocity
				airSpeedControl = 0.3; // give linear velocity in the air // Note: Might be a liiittle too much. Just your preference.
				groundSpeedControl = 0.3; // give linear velocity on ground
			}
			var baseHeight:Number = 32.9; // (Box2D value) anything above this means they are below the stage - this is ground level (opposite logic since origin starts in top-left)
			// Left ('A' or Left)
			var heightAirControl:Number = 3; // (Box2D value) height above baseHeight at which can do air control
			var speed:b2Vec2 = _obj.GetLinearVelocity(); // holds the speed at points in this method
			if (FlxG.keys.pressed(leftControl)) {
				facing = FlxObject.LEFT;
				// If we're in the air
				if (_obj.GetPosition().y < (baseHeight - heightAirControl)) {
					_obj.SetLinearVelocity(new b2Vec2(speed.x - airSpeedControl, speed.y));
					//_obj.ApplyForce(new b2Vec2(-airSpeedControl*10*2, 0), _obj.GetPosition());
				}
				// Else on the ground
				else {
					// If we are going right, allow Left to combat it better
					if (_obj.GetAngularVelocity() > 0)
						angVelMult = angOppositeMult;
					_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 1 * angVelMult)
					_obj.SetLinearVelocity(new b2Vec2(speed.x - groundSpeedControl, speed.y));
				}
			}
			// Right ('D' or Right)
			else if (FlxG.keys.pressed(rightControl)) {
				facing = FlxObject.RIGHT;
				// If we're in the air
				if (_obj.GetPosition().y < (baseHeight - heightAirControl)) {
					_obj.SetLinearVelocity(new b2Vec2(speed.x + airSpeedControl, speed.y));
					//_obj.ApplyForce(new b2Vec2(airSpeedControl*10*2, 0), _obj.GetPosition());
				}
				else {
					// If we are going left, allow Right to combat it better
					if (_obj.GetAngularVelocity() < 0)
						angVelMult = angOppositeMult;
					_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 1 * angVelMult)
					_obj.SetLinearVelocity(new b2Vec2(speed.x + groundSpeedControl, speed.y));
				}
			}
			// Getting correct running sprite
			imageIndex += _obj.GetAngularVelocity() * 5.625 / 36
			if (imageIndex >= 16) imageIndex -= 16;
			if (imageIndex < 0) imageIndex += 16;
			frame = Math.floor(imageIndex);
			// Jumping ('W' or Up)
			if (FlxG.keys.justPressed(jumpControl)) {
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())
			}
			// Keeping linear speed reasonable
			speed = _obj.GetLinearVelocity()
			/* Repeat of original movement code - why? Y U NO LYKE MAI NOO KOUD? */
			/*if (FlxG.keys.pressed(leftControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 1)
			else if (FlxG.keys.pressed(rightControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 1)
			if (FlxG.keys.justPressed(jumpControl))
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())*/
			if (type == 0)
				_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -54, 54), speed.y))
			else
				_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -36, 36), speed.y))
			
			super.update()
			
			if (x > FlxG.width || x < -width || y > FlxG.height) {
				PlayState(FlxG.state).remove(this);
				PlayState(FlxG.state).win(enemyName);
			}
		}
		public function calculateJumpDir():b2Vec2 {
			var dir:b2Vec2 = new b2Vec2(),
				otherDir:b2Vec2 = new b2Vec2
			for (var key:Object in normalsFromCollisions) {
				var otherObject:b2Body = key as b2Body,
					normalFromOther:b2Vec2 = normalsFromCollisions[key]
				dir.Add(normalFromOther)
				otherDir = normalFromOther.GetNegative()
				otherDir.Multiply(type == 3 ? repulsionSpeed * 1.5 : repulsionSpeed) //type 3 pushes harder
				otherObject.ApplyImpulse(otherDir, otherObject.GetPosition())
			}
			dir.Normalize()
			dir.Multiply(type == 2 ? repulsionSpeed * 1.5 : repulsionSpeed) //type 2 jumps higher
			return dir
		}
		
		public function resetAt(X:Number, Y:Number):void {
			SetPosition(X, Y);
			_obj.SetLinearVelocity(new b2Vec2(0, 0));
			_obj.SetAngularVelocity(0);
		}
		
		// Sounds
		override public function addNormal(obj:b2Body, dir:b2Vec2):void {
			//FlxG.play(snd_HarshHit); // slightly slower
			snd_Hit.play(true);
			super.addNormal(obj, dir);
		}
		
		override public function subtractNormal(obj:b2Body):void {
			super.subtractNormal(obj);
		}
	}
}
