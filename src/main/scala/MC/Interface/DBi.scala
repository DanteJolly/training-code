package MC.Interface

import MC.Dao.MCDao
import com.mongodb.client.model.Filters
import org.mongodb.scala.MongoClient
import org.mongodb.scala.model.Projections.{exclude, include}

import scala.io.StdIn
import scala.util.matching.Regex

class DBi(protein:List[String]) {

  val client=MongoClient()
  val db= new MCDao(client,protein)
  val commandArgPattern: Regex = "(\\w+)\\s*(.*)".r

  def printOpen(): Unit = {
    println("Database Menu")
  }

  def printOption(): Unit = {
    println("Please Enter an Option Below")
    println("Match: Matches protein strain with another in the database.")
    println("Search: Search for a mutation ")
    println("Insert: Insert a mutation if there is none in the database")
    println("Back: Goes back to main menu.")
    println("Exit; Close")
  }

  def menu(): Unit = {
    printOpen()

    var continue = true;


    while (continue) {
      printOption()

      StdIn.readLine() match {
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase("Match") => {
          if (db.matcher().isEmpty){
            println("No available match")
          }
          else println(db.matcher()(0))
        }
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase("Search") => {
          println("Type name of Gene")
          var name=StdIn.readLine()
          db.findGeneName(name)
        }
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase("Insert") => {
          println("Insert name of mutation")
          var name=StdIn.readLine()

          println("Insert Description of mutation ")
          var description=StdIn.readLine()
          db.insertGene(name,description)
        }
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase("Back") => {
            new MCi().menu()
        }
        case notRecognized => println(s"$notRecognized not a recognized command")

      }
    }
  }
}

