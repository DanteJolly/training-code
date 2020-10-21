package MC.Dao

import org.bson.types.ObjectId



//Any class that represents document should be similiar to this:
// it needs a _id field

case class MCDB(_id: ObjectId, Name: String, Gene: Option[String], Description: Option[String]) {}

  object MCDB {
  def apply(Name:String, Gene:Option[String], Description: Option[String]) : MCDB = MCDB(new ObjectId(), Name, Gene, Description)
}