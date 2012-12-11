package RobotGame 
{
	import adobe.utils.CustomActions;
	import flash.sampler.NewObjectSample;
	import org.flixel.*
	import Box2D.Dynamics.*
	import Box2D.Collision.*
	import Box2D.Collision.Shapes.*
	import Box2D.Common.Math.*
	
	public class PlayState extends FlxState
	{
		// World
		public var _world:b2World
		// Stage
		public var floor:Wall
		public var platformLeft:Wall
		public var platformRight:Wall
		public var platformTop:Wall
		public var floorLeft:Wall
		public var floorRight:Wall
		public var wallLeft:Wall
		public var wallRight:Wall
		// Background
		[Embed(source = '../resources/Robo_Bkgrd.png')] private var sprBG:Class;
		// Players
		public var NO_WINNER:Number = 0;
		//public var bottomOfStage:Number = 50.0; // might be less, but this is fine (768/20)
		public var player1:Robot
		public var player1_ID:Number = 1;
		public var player1_startX:Number = (1024 - 640) - 98/*width of Robot*/; // was 320 (now 286)
		public var player2:Robot
		public var player2_ID:Number = 2;
		public var player2_startX:Number = 640;
		public var players_startY:Number = 240;
		// Game state
		public var winner:Number = NO_WINNER;
		public var score:Number = 0;
		public var player1_damg:Number = 0.0; // [0.0, 10.0] // for the lulz
		public var player2_damg:Number = 0.0; // [0.0, 10.0]
		public static var p1type:int = 0, p2type:int = 3;
		private var gameEnd:Boolean = false;
		// Music
		[Embed(source = '../resources/RobotSong.mp3')] private var bgMusic:Class;
		
		override public function create(): void {
			super.create()
			var gravity:b2Vec2 = new b2Vec2(0, 9.8*2)
			_world = new b2World(gravity, false)
			_world.SetContactListener(new ContactListener())
			//FlxG.worldBounds = new FlxRect(0, 0, 1024, 768)
			
			add(new FlxSprite(0, 0, sprBG));
						
			initializePlayers();
			
			makeStage();
			
			initializeMusic();
		}
		
		public function initializePlayers():void {
			add(player1 = new Robot(_world, player1_startX, players_startY, "W", "A", "D", p1type, "Player 2"))
			add(player2 = new Robot(_world, player2_startX, players_startY, "UP", "LEFT", "RIGHT", p2type, "Player 1"))
		}
		
		public function makeStage():void {
			// Single platform ' _____ '
			//add(floor = new Wall(_world, 64, FlxG.height - 64, FlxG.width - 128, 64))
			// Multiple platforms '_ ___ _'
			//var blockWidth:Number = 100;
			//var platHeight:Number = 64;
			//var platSpacing:Number = 200;
			//var wallWidth:Number = 10;
			//var wallHeight:Number = 768 + 100; // for good measure
			// Floor(s)
			//add(floorLeft = new Wall(_world, 0, FlxG.height - platHeight, blockWidth, platHeight))
			//add(floor = new Wall(_world, blockWidth + platSpacing, FlxG.height - platHeight, FlxG.width - (blockWidth + platSpacing) * 2, platHeight))
			//add(floorRight = new Wall(_world, FlxG.width - blockWidth, FlxG.height - platHeight, blockWidth, platHeight))
			// Walls
			//add(wallLeft = new Wall(_world, -wallWidth, 0, wallWidth, wallHeight))
			//add(wallRight = new Wall(_world, FlxG.width, 0, wallWidth, wallHeight))
			//add(new Wall(_world, 0, 0, FlxG.width, 2)) // ceiling // adding this with restitution of 10 is quite cool 8O
			
			add(floor = new Wall(_world, 160, 428, 710, 24, 0))
			add(platformTop = new Wall(_world, 435, 178, 165, 20, 0))
			add(platformLeft = new Wall(_world, 351.5, 309, 160, 20, -16))
			add(platformRight = new Wall(_world, 672.5, 309, 160, 20, 16))
		}
		
		public function initializeMusic():void {
			FlxG.play(bgMusic, 1, true);
		}
		
/*		public function resetRobotGame():void {
			player1.resetAt(player1_startX, players_startY);
			player2.resetAt(player2_startX, players_startY);
			
			winner = NO_WINNER;
			score = 0;
			add(player = new Robot(_world, 320, 240, "W", "A", "D", p1type, "Player 1"))
			add(new Robot(_world, 640, 240, "UP", "LEFT", "RIGHT", p2type, "Player 2"))
			add(floor = new Wall(_world, 64, FlxG.height - 64, FlxG.width - 128, 64))
		}
*/		
		override public function update():void {
			super.update()
			_world.Step(FlxG.elapsed, 10, 10)
			_world.ClearForces();
			
			/*if (winner == NO_WINNER) {
				// Still playing
				if (player1.y > FlxG.height) {
					//_world.DestroyBody(player1._obj);
					winner = player2_ID;
				}
				else if (player2.y > FlxG.height) {
					//_world.DestroyBody(player2._obj);
					winner = player1_ID;
				}
			}
			else {
				// Sombody won - TODO: display text
				// Display it until you click (because if use one of the player movements, they may still be holding that key)
				if (FlxG.mouse.pressed()) {
					resetRobotGame();
				}*/
			if (gameEnd) {
				if (FlxG.keys.justPressed("SPACE")) {
					FlxG.switchState(new MenuState());
				}
			}
		}
		
		public function win(winner:String):void {
				var newText:FlxText;
			if (!gameEnd) {
				newText = FlxText(add(new FlxText(0, 0, FlxG.width, winner + " wins!")));
				newText.alignment = "center";
				newText.size = 70;
				gameEnd = true;
			}
			else {
				newText = FlxText(add(new FlxText(0, 75, FlxG.width, "(but you both suck)")));
				newText.alignment = "center";
				newText.size = 15;
			}
			newText.font = "stencil";
		}
	}

}