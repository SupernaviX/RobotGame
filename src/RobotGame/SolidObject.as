package RobotGame 
{
	import org.flixel.*
	import Box2D.Dynamics.*
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*
	
	public class SolidObject extends FlxSprite
	{
		public var ratio:Number = 20; // FTFY (public so can access from PlayState)
		
		//public var _fixDef:b2FixtureDef
		//public var _bodyDef:b2BodyDef
		public var _obj:b2Body
		
		private var _world:b2World
		
		//public var _friction:Number = 0.8
		//public var _restitution:Number = 0.3
		//public var _density:Number = 0.7
		
		//public var _angle:Number = 0
		//public var _type:uint
		
		public function SolidObject(world:b2World, X:Number, Y:Number, SimpleGraphic:Class = null ) 
		{
			super(X, Y, SimpleGraphic)
			_world = world
		}
		
		public function createBody(body:b2Shape, type:uint, friction:Number = 0.2, restitution:Number = 0.3, density:Number = 0.7):void {
			var _fixDef:b2FixtureDef = new b2FixtureDef()
			_fixDef.density = density
			_fixDef.restitution = restitution
			_fixDef.friction = friction
			_fixDef.shape = body
			_fixDef.userData = this
			
			var _bodyDef:b2BodyDef = new b2BodyDef();
			_bodyDef.position.Set((x + (width / 2)) / ratio, (y + (height / 2)) / ratio)
			_bodyDef.angle = 0
			_bodyDef.fixedRotation = false
			_bodyDef.userData = this
			_bodyDef.type = type
			
			_obj = _world.CreateBody(_bodyDef)
			_obj.CreateFixture(_fixDef)
		}
		
		public function SetPosition(X:Number, Y:Number):void {
			x = X;
			y = Y;
			_obj.SetPosition(new b2Vec2((X + (width / 2)) / ratio, (Y + (height / 2)) / ratio));
		}
		
		override public function update():void {
			x = (_obj.GetPosition().x * ratio) - (width / 2)
			y = (_obj.GetPosition().y * ratio) - (height / 2)
		}
	}
}