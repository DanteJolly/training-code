package MC.Interface

import java.io.FileNotFoundException

import MC.Backend.{DNA, FileUtil}

import scala.io.StdIn
import scala.util.matching.Regex

class MCi {

  val protein: List[String]=List()

  val commandArgPattern: Regex= "(\\w+)\\s*(.*)".r

  def printOpen():Unit= {
      println("Welcome to Mutation Catcher")
  }

  def printOption(): Unit={
    println("Please Enter an Option Below")
    println("File: Select File")
    println("DNA: DNA section")
    println("Database: Genome Database")
    println("Exit: Close Program")
  }
  var file:String=""


  def menu(): Unit = {
    printOpen()

    var continue = true;


    while (continue){
      printOption()

      StdIn.readLine() match{
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "file")=> {
          try {
            FileUtil.getTextcontent(arg)
              .getOrElse("No Content")
              .replaceAll("\\p{Punct}", "")
              .split("\\s+")
            println("Success")
            file=FileUtil.readText(arg)
          } catch {
            case fnf: FileNotFoundException => println(s"Failed to find file $arg")
          }
        }
        case commandArgPattern(cmd , arg) if cmd.equalsIgnoreCase("DNA") => {
         new DNAi(file.toList).menu()
        }

        case commandArgPattern(cmd , arg) if cmd.equalsIgnoreCase("Database") => {

          new DBi(protein).menu()
        }
        case commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "Exit")=>  continue=false
        case notRecognized => println(s"$notRecognized not a recognized command")
      }
    }
    println("Goodbye")





  }
}
