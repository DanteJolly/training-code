package MC.Interface

import MC.Backend.DNA

import scala.io.StdIn
import scala.util.matching.Regex

class DNAi(strand:List[Char]) {

  val dna=new DNA(strand)
  val commandArgPattern: Regex= "(\\w+)\\s*(.*)".r

  def printOpen(): Unit ={
    println("DNA section")
  }

  def printOptions(): Unit={
    println("Enter an Option Below")
    println("Show: Show DNA strand")
    println("NC: Show Nucleotides")
    println("RNA: Show mRNA strand")
    println("Protein: Convert to Protein")
    println("Back: Go back to main menu")
  }

  def menu(): Unit = {
    printOpen()

    var continue = true;


    while (continue){
      printOptions()

      StdIn.readLine() match{
        case  commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "Show")=>{
          println("DNA strand")
          println(strand.mkString(""))
        }
        case  commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "NC")=>{
          println("# for each nucleotide")
          dna.ncCount()

        }
        case  commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "RNA")=>{
          println("RNA sequence")
          println(dna.rna)
        }
        case  commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "Protein")=>{
          println("Converting to protein")
          dna.convertprotein()
          dna.printProtein()
          new DBi(dna.protein).menu()
        }
        case  commandArgPattern(cmd, arg) if cmd.equalsIgnoreCase( "Back")=>{
          continue=false
          new MCi().menu()
        }
        case   notRecognized => println(s"$notRecognized not a recognized command")
      }
      }
      }
}
