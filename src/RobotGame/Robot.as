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
		public var contactsAndDirections:Dictionary;
		public var jumpDir:b2Vec2
		public var jumpControl:String
		public var leftControl:String
		public var rightControl:String
		public var repulsionSpeed:Number = 192*1.5; // 2 is too much
		private var imageIndex:Number = 0;
		
		[Embed(source='../resources/roball.png')] public var sprRobot: Class
		public function Robot(World:b2World, X:Number, Y:Number, JumpControl:String, LeftControl:String, RightControl:String) 
		{
			super(World, X, Y)
			contactsAndDirections = new Dictionary()
			jumpControl = JumpControl
			leftControl = LeftControl
			rightControl = RightControl
			this.loadGraphic(sprRobot,true,true,98,98)
			//this.makeGraphic(96, 96)
			var shape:b2CircleShape = new b2CircleShape(48/ratio)
			createBody(shape, b2Body.b2_dynamicBody)
			_obj.SetLinearDamping(0.1)
			_obj.SetAngularDamping(5)
			_obj.GetFixtureList().SetRestitution(0.1) // dunno? Still bouncy.
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
//				canJump = false
			}
			// Keeping linear speed reasonable
			speed = _obj.GetLinearVelocity()
			_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -36, 36), speed.y))
			
			super.update()
		}
		public function addContact(obj:b2Body, dir:b2Vec2):void {
			contactsAndDirections[obj] = dir
		}
		public function subtractContact(obj:b2Body):void {
			delete contactsAndDirections[obj]
		}
		public function calculateJumpDir():b2Vec2 {
			var dir:b2Vec2 = new b2Vec2()
			for each (var value:b2Vec2 in contactsAndDirections) {
				dir.Add(value)
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