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
		public var repulsionSpeed:Number = 16
		
		//[Embed(src = "../resources/robot.png")]public var sprRobot: Class
		public function Robot(World:b2World, X:Number, Y:Number, JumpControl:String, LeftControl:String, RightControl:String) 
		{
			super(World, X, Y)
			contactsAndDirections = new Dictionary()
			jumpControl = JumpControl
			leftControl = LeftControl
			rightControl = RightControl
			//this.loadGraphic(sprRobot)
			this.makeGraphic(32, 32)
			var shape:b2CircleShape = new b2CircleShape(16/ratio)
			createBody(shape, b2Body.b2_dynamicBody)
			_obj.SetLinearDamping(0.1)
		}
		override public function update():void {
			var multiplier:Number = _obj.GetMass()
			if (FlxG.keys.pressed(leftControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 1)
			else if (FlxG.keys.pressed(rightControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 1)
			if (FlxG.keys.justPressed(jumpControl)) {
				
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())
//				canJump = false
			}
			var speed:b2Vec2 = _obj.GetLinearVelocity()
			_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -12, 12), speed.y))
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
	}
}