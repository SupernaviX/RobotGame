package RobotGame 
{
	import Box2D.Collision.*
	import Box2D.Dynamics.*
	import Box2D.Dynamics.Contacts.*
	import Box2D.Common.Math.*
	public class ContactListener extends b2ContactListener
	{
		override public function BeginContact(contact:b2Contact):void {
			var first:Robot = (contact.GetFixtureA().GetUserData() is Robot) ? contact.GetFixtureA().GetUserData() : null,
				second:Robot = (contact.GetFixtureB().GetUserData() is Robot) ? contact.GetFixtureB().GetUserData() : null
			if (first != null) {
				var fDir:b2Vec2 = new b2Vec2()
				if (contact.GetManifold().m_type == b2Manifold.e_circles) {
					fDir.Add(contact.GetFixtureA().GetBody().GetPosition())
					fDir.Subtract(contact.GetFixtureB().GetBody().GetPosition())
					fDir.Normalize()
				}
				else if (contact.GetManifold().m_type == b2Manifold.e_faceA)
					fDir.Subtract(contact.GetManifold().m_localPlaneNormal)
				else
					fDir.Add(contact.GetManifold().m_localPlaneNormal)
				first.addContact(contact.GetFixtureB().GetBody(), fDir)
			}
			if (second != null) {
				var sDir:b2Vec2 = new b2Vec2()
				if (contact.GetManifold().m_type == b2Manifold.e_circles) {
					sDir.Add(contact.GetFixtureB().GetBody().GetPosition())
					sDir.Subtract(contact.GetFixtureA().GetBody().GetPosition())
					sDir.Normalize()
				}
				else if (contact.GetManifold().m_type == b2Manifold.e_faceA)
					sDir.Add(contact.GetManifold().m_localPlaneNormal)
				else
					sDir.Subtract(contact.GetManifold().m_localPlaneNormal)
				second.addContact(contact.GetFixtureA().GetBody(), sDir)
			}
		}
		
		override public function EndContact(contact:b2Contact):void {
			var first:Robot = (contact.GetFixtureA().GetUserData() is Robot) ? contact.GetFixtureA().GetUserData() : null,
				second:Robot = (contact.GetFixtureB().GetUserData() is Robot) ? contact.GetFixtureB().GetUserData() : null
			if (first != null)
				first.subtractContact(contact.GetFixtureB().GetBody())
			if (second != null)
				second.subtractContact(contact.GetFixtureA().GetBody())
		}
	}
}