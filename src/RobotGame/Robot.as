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
		public var jumpDir:b2Vec2
		public var jumpControl:String
		public var leftControl:String
		public var rightControl:String
		public var repulsionSpeed:Number = 192
		
		//[Embed(src = "../resources/robot.png")]public var sprRobot: Class
		public function Robot(World:b2World, X:Number, Y:Number, JumpControl:String, LeftControl:String, RightControl:String) 
		{
			super(World, X, Y)
			jumpControl = JumpControl
			leftControl = LeftControl
			rightControl = RightControl
			//this.loadGraphic(sprRobot)
			this.makeGraphic(96, 96)
			var shape:b2CircleShape = new b2CircleShape(48/ratio)
			createBody(shape, b2Body.b2_dynamicBody)
			_obj.SetLinearDamping(0.1)
		}
		override public function update():void {
			var multiplier:Number = _obj.GetMass()
			if (FlxG.keys.pressed(leftControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() - 1)
			else if (FlxG.keys.pressed(rightControl))
				_obj.SetAngularVelocity(_obj.GetAngularVelocity() + 1)
			if (FlxG.keys.justPressed(jumpControl))
				_obj.ApplyImpulse(calculateJumpDir(), _obj.GetPosition())
			var speed:b2Vec2 = _obj.GetLinearVelocity()
			_obj.SetLinearVelocity(new b2Vec2(b2Math.Clamp(speed.x, -36, 36), speed.y))
			super.update()
		}
		public function calculateJumpDir():b2Vec2 {
			var dir:b2Vec2 = new b2Vec2()
			for (var key:Object in normalsFromCollisions) {
				var otherObject:b2Body = key as b2Body,
					otherDir:b2Vec2 = normalsFromCollisions[key]
				dir.Add(otherDir)
				otherDir.NegativeSelf()
				otherDir.Multiply(repulsionSpeed)
				otherObject.ApplyImpulse(otherDir, otherObject.GetPosition())
			}
			dir.Normalize()
			dir.Multiply(repulsionSpeed)
			return dir
		}
	}
}