package RobotGame
{
	import org.flixel.*;
	[SWF(width = "1024", height = "538", backgroundColor = "#000000")]
	public class RobotGame extends FlxGame
	{		
		public function RobotGame()
		{
			super(1024, 538, RobotGame.MenuState, 1);
			forceDebugger = true;
		}
		
	}
}