package MC.Backend

class DNA (nt:List[Char]){

  val strand=nt
  val rna=convertRNA()
  var protein: List[String]=List()

  def printDNA(): Unit ={
    print(strand)
  }

   def convertRNA():List[Char]={
     strand.map({case'T'=>'U'; case x=> x})

  }

  def convertprotein() {
    var aa=rna.grouped(3).toArray
    var container:List[Char]=List()
    for(i <-aa.indices){
      (0 to 2)
        .foreach(f = j => if (container.length == 3) {
          this.protein = protein :+ BioReferences.amino_acid(container.mkString(""))
          container = List()
        } else container = container :+ aa(i)(j))
     }
    }

  def ncCount(): Unit ={
    var A,C,T,G=0
    for(i<-0 to strand.length-1) strand(i) match{
      case 'A' => A+=1
      case 'C' => C+=1
      case 'T' => T+=1
      case 'G' => G+=1
    }
    println("Nucleotide A count =" + A)
    println("Nucleotide C count =" + C)
    println("Nucleotide T count =" + T)
    println("Nucleotide G count =" + A)
  }

  def printProtein(): Unit={
    print(protein.mkString(""))
  }



}
