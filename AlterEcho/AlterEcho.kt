import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO
import kotlin.experimental.and
import kotlin.experimental.or

const val AUTHOR = "Jashin L."

class AlterEcho {
    private fun getBit(n: Int, position: Int): Boolean {
        return n shr position and 1 == 1
    }

    private fun setBit(n: Int, position: Int, value: Boolean): Int {
        return if (value)
            n or (1 shl position)
        else
            n and (1 shl position).inv()
    }

    fun hideMessage(imagePath: String, message: String, outputPath: String) {
        val image = ImageIO.read(File(imagePath))
        val messageLength = message.length
        var messageIndex = 0
        var bitIndex = 0

        for (y in 0 until image.height) {
            for (x in 0 until image.width) {
                if (messageIndex >= messageLength) break

                val pixel = image.getRGB(x, y)
                val red = pixel shr 16 and 0xff
                val green = pixel shr 8 and 0xff
                val blue = pixel and 0xff

                if (bitIndex < 8) {
                    val newRed = setBit(red, 0, getBit(message[messageIndex].code, bitIndex))
                    image.setRGB(x, y, (pixel and 0xff00ffff.toInt()) or (newRed shl 16))
                    bitIndex++
                } else {
                    messageIndex++
                    bitIndex = 0
                }
            }
        }

        ImageIO.write(image, "png", File(outputPath))
    }

    fun extractMessage(imagePath: String, messageLength: Int): String {
        val image = ImageIO.read(File(imagePath))
        val message = StringBuilder()
        var currentChar = 0
        var bitIndex = 0

        for (y in 0 until image.height) {
            for (x in 0 until image.width) {
                if (message.length >= messageLength) break

                val pixel = image.getRGB(x, y)
                val red = pixel shr 16 and 0xff

                if (bitIndex < 8) {
                    currentChar = setBit(currentChar, bitIndex, getBit(red, 0))
                    bitIndex++
                } else {
                    message.append(currentChar.toChar())
                    currentChar = 0
                    bitIndex = 0
                }
            }
        }

        return message.toString()
    }

    fun hideFile(imagePath: String, filePath: String, outputPath: String) {
        val fileData = File(filePath).readBytes()
        val fileDataString = String(fileData)
        hideMessage(imagePath, fileDataString, outputPath)
    }

    fun extractFile(imagePath: String, outputPath: String, fileLength: Int) {
        val fileData = extractMessage(imagePath, fileLength)
        File(outputPath).writeBytes(fileData.toByteArray())
    }
}

fun main(args: Array<String>) {
    val alterEcho = AlterEcho()
    
    when (args[0]) {
        "-h", "--hide" -> alterEcho.hideMessage(args[1], args[2], args[3])
        "-e", "--extract" -> println(alterEcho.extractMessage(args[1], args[2].toInt()))
        "-hf", "--hide-file" -> alterEcho.hideFile(args[1], args[2], args[3])
        "-ef", "--extract-file" -> alterEcho.extractFile(args[1], args[2], args[3].toInt())
        else -> {
            println("Usage:")
            println("Hide message: -h [image] [message] [output]")
            println("Extract message: -e [image] [length]")
            println("Hide file: -hf [image] [file] [output]")
            println("Extract file: -ef [image] [output] [length]")
        }
    }
}
