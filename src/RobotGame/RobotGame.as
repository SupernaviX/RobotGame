package RobotGame
{
	import org.flixel.*;
	[SWF(width = "1024", height = "768", backgroundColor = "#000000")]
	public class RobotGame extends FlxGame
	{
		public function RobotGame()
		{
			super(1024, 768, PlayState, 1);
		}
		
	}
}