package RobotGame 
{
	import Box2D.Collision.*
	import Box2D.Dynamics.*
	import Box2D.Dynamics.Contacts.*
	import Box2D.Common.Math.*
	public class ContactListener extends b2ContactListener
	{
		override public function BeginContact(contact:b2Contact):void {
			var first:SolidObject = contact.GetFixtureA().GetBody().GetUserData(),
				second:SolidObject = contact.GetFixtureB().GetBody().GetUserData(),
				dir:b2Vec2 = new b2Vec2()
			switch (contact.GetManifold().m_type) {
			case b2Manifold.e_circles:
				dir.Add(contact.GetFixtureA().GetBody().GetPosition())
				dir.Subtract(contact.GetFixtureB().GetBody().GetPosition())
				dir.Normalize()
				break
			case b2Manifold.e_faceA:
				dir.Subtract(contact.GetManifold().m_localPlaneNormal)
				break
			case b2Manifold.e_faceB:
				dir.Add(contact.GetManifold().m_localPlaneNormal)
				break
			}
			first.addNormal(contact.GetFixtureB().GetBody(), dir)
			second.addNormal(contact.GetFixtureA().GetBody(), dir.GetNegative())
		}
		
		override public function EndContact(contact:b2Contact):void {
			var first:Robot = (contact.GetFixtureA().GetUserData() is Robot) ? contact.GetFixtureA().GetUserData() : null,
				second:Robot = (contact.GetFixtureB().GetUserData() is Robot) ? contact.GetFixtureB().GetUserData() : null
			if (first != null)
				first.subtractNormal(contact.GetFixtureB().GetBody())
			if (second != null)
				second.subtractNormal(contact.GetFixtureA().GetBody())
		}
	}
}