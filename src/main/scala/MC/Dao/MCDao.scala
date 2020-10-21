package MC.Dao

import org.mongodb.scala.{MongoClient, MongoCollection, Observable}

import scala.concurrent.Await
import scala.concurrent.duration.{Duration, SECONDS}
import org.bson.codecs.configuration.CodecRegistries.{fromProviders, fromRegistries}
import org.mongodb.scala.bson.codecs.Macros._
import org.mongodb.scala.model.Filters._
import org.mongodb.scala.model.Updates._
import org.mongodb.scala.model.Sorts._
import org.mongodb.scala.model.Projections._
import org.bson.BsonNull
import com.mongodb.client.model.Filters
import javax.lang.model.element.NestingKind


class MCDao(mongoClient: MongoClient,protein:List[String]) {


  val codecRegistry = fromRegistries(fromProviders(classOf[MCDB]), MongoClient.DEFAULT_CODEC_REGISTRY)
  val db = mongoClient.getDatabase("GeneDB").withCodecRegistry(codecRegistry)
  val collection : MongoCollection[MCDB] = db.getCollection("Genes")

  def getResults[T](obs: Observable[T]): Seq[T] = {
    Await.result(obs.toFuture(), Duration(10, SECONDS))
  }
  def printResults[T](obs: Observable[T]): Unit = {
    getResults(obs).foreach(println(_))
  }
  def getAll(): Seq[MCDB]=getResults(collection.find())

  def printAll(): Unit={
    println(getAll())
  }

  def printProjection(): Unit ={
    printResults(collection.find().projection(exclude("Gene")))

  }
  def justGene()=printResults(collection.find().projection(include("Name","Gene" )))

  def matcher(): Seq[MCDB]= getResults(collection.find(Filters.eq("Gene",protein.mkString(""))))

  def insertGene(name:String,description:String){
      if(getResults(collection.find(Filters.eq("Name",name))).isEmpty
        && getResults(collection.find(Filters.eq("Gene",protein.mkString("")))).isEmpty) {
        printResults(collection.insertOne(MCDB(name, Some(protein.mkString("")), Some(description))))
      }
      else println("Already in the Database")
  }


  def findGeneName(name:String): Unit ={
    if (getResults(collection.find(Filters.eq("Name",name)).projection(exclude("Gene")).projection(include("Name","Description"))).isEmpty){
      println("No gene found")
    }
    else println(getResults(collection.find(Filters.eq("Name",name)).projection(exclude("Gene")).projection(include("Name","Description"))))
  }

}

