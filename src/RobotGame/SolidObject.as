package RobotGame 
{
	import flash.utils.Dictionary;
	import org.flixel.*
	import Box2D.Dynamics.*
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*
	
	public class SolidObject extends FlxSprite
	{
		protected var ratio:Number = 20
		
		public var _obj:b2Body
		protected var normalsFromCollisions:Dictionary
		private var _world:b2World
		
		public function SolidObject(world:b2World, X:Number, Y:Number, SimpleGraphic:Class = null ) 
		{
			super(X, Y, SimpleGraphic)
			normalsFromCollisions = new Dictionary()
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

		public function addNormal(obj:b2Body, dir:b2Vec2):void {
			normalsFromCollisions[obj] = dir
		}
		
		public function subtractNormal(obj:b2Body):void {
			delete normalsFromCollisions[obj]
		}

		override public function update():void {
			x = (_obj.GetPosition().x * ratio) - (width / 2)
			y = (_obj.GetPosition().y * ratio) - (height / 2)
		}
	}
}