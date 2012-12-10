package RobotGame 
{
	import flash.sampler.NewObjectSample;
	import org.flixel.*
	import Box2D.Dynamics.*
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*

	public class PlayState extends FlxState
	{
		public var player:Robot
		public var floor:Wall
		public var _world:b2World
		
		override public function create(): void {
			super.create()
			var gravity:b2Vec2 = new b2Vec2(0, 9.8*2)
			_world = new b2World(gravity, false)
			_world.SetContactListener(new ContactListener())
			
			add(player = new Robot(_world, 320, 240, "W", "A", "D"))
			add(new Robot(_world, 640, 240, "UP", "LEFT", "RIGHT"))
			add(floor = new Wall(_world, 64, FlxG.height - 64, FlxG.width - 128, 64))
		}
		
		override public function update():void {
			super.update()
			var xSpeed:Number,
				ySpeed:Number
			_world.Step(FlxG.elapsed, 10, 10)
			_world.ClearForces();
		}
	}

}