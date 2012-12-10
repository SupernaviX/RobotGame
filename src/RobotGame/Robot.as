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
		
		public var contactsAndDirections:Dictionary;
		public var jumpDir:b2Vec2
		public var jumpControl:String
		public var leftControl:String
		public var rightControl:String
		public var repulsionSpeed:Number = 32
		private var imageIndex:Number = 0;
		private var type:int;
		private var name:String;
		
		public function Robot(World:b2World, X:Number, Y:Number, JumpControl:String, LeftControl:String, RightControl:String, Type:int, Name:String) 
		{
			super(World, X, Y)
			jumpControl = JumpControl
			leftControl = LeftControl
			rightControl = RightControl
			this.loadGraphic(charSprites[Type],true,true,49,49)
			//this.makeGraphic(96, 96)
			var shape:b2CircleShape = new b2CircleShape(24.5/ratio)
			createBody(shape, b2Body.b2_dynamicBody)
			_obj.SetLinearDamping(0.1)
			_obj.SetAngularDamping(5)
			_obj.GetFixtureList().SetRestitution(0.1) // dunno? Still bouncy.
			_obj.SetLinearDamping(0.1);
			type = Type;
			name = Name;
		}
		override public function update():void {
			var multiplier:Number = _obj.GetMass()
			var angVelMult:Number = 1; // holds any mults to increase angular velocity (e.g. angOppositeMult)
			var angOppositeMult:Number = 1.3; // mult to increase angular velocity
			var baseHeight:Number = 32.9; // anything above this means they are below the stage - this is ground level (opposite logic since origin starts in top-left)
			// Left ('A' or Left)
			var heightAirControl:Number = 3; // height above baseHeight at which can do air control
			var airSpeedControl:Number = 0.3; // give linear velocity in the air // Note: Might be a liiittle too much. Just your preference.
			var groundSpeedControl:Number = 0.3; // give linear velocity on ground
			var speed:b2Vec2 = _obj.GetLinearVelocity(); // holds the speed at points in this method
			if (FlxG.keys.pressed(leftControl)) {
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
			imageIndex += _obj.GetAngularVelocity() * 5.625 / 360
			if (imageIndex >= 16) imageIndex -= 16;
			if (imageIndex < 0) imageIndex += 16;
			frame = Math.floor(imageIndex);
			// Jumping ('W' or Up)
			if (FlxG.keys.justPressed(jumpControl)) {
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())
			}
			// Keeping linear speed reasonable
			speed = _obj.GetLinearVelocity()
			if (FlxG.keys.pressed(leftControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 1)
			else if (FlxG.keys.pressed(rightControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 1)
			if (FlxG.keys.justPressed(jumpControl))
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())
			_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -36, 36), speed.y))
			
			super.update()
			
			if (x > FlxG.width || x < -width || y > FlxG.height) {
				PlayState(FlxG.state).remove(this);
				PlayState(FlxG.state).win(name);
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
				otherDir.Multiply(repulsionSpeed)
				otherObject.ApplyImpulse(otherDir, otherObject.GetPosition())
			}
			dir.Normalize()
			dir.Multiply(repulsionSpeed)
			return dir
		}
		
		public function resetAt(X:Number, Y:Number):void {
			SetPosition(X, Y);
			_obj.SetLinearVelocity(new b2Vec2(0, 0));
			_obj.SetAngularVelocity(0);
		}
	}
}