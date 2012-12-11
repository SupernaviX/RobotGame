package RobotGame 
{
	import org.flixel.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	public class Wall extends SolidObject 
	{
		
		public function Wall(World:b2World, X:Number, Y:Number, Width:Number, Height:Number, Angle:Number)
		{
			super(World, Angle == 0 ? X : X - (Width / 2), Angle == 0 ? Y : Y - (Height / 2));
			width = Width;
			height = Height;
			var shape:b2PolygonShape = new b2PolygonShape();
			//shape.SetAsBox((width / 2) / ratio, (height / 2) / ratio);
			shape.SetAsOrientedBox((width / 2) / ratio, (height / 2) / ratio, b2Vec2.Make(0,0), Angle);
			createBody(shape, b2Body.b2_staticBody, 1.5);
			//makeGraphic(width, height, 0xffaaaaaa);
			visible = false
		}
		
	}

}