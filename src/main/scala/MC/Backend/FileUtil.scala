package MC.Backend

import scala.io.{BufferedSource, Source}

object FileUtil {

  def getTextcontent(filename: String): Option[String] = {
    var openedFile: BufferedSource = null
    try {
      openedFile = Source.fromFile(filename)


      Some(openedFile.getLines().mkString(" "))
    } finally if (openedFile == null) {

    } else openedFile.close

  }

  def readText(fileName: String): String = {
    val bufferedSource = Source.fromFile(fileName)
    val fileContents = Source.fromFile(fileName).getLines().mkString("")
    bufferedSource.close()
    return fileContents
  }
}
