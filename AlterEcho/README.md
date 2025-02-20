kotlinc AlterEcho.kt -include-runtime -d alterecho.jar

possible uses :

java -jar alterecho.jar -h input.png "secret message" output.png

java -jar alterecho.jar -e output.png 13

java -jar alterecho.jar -hf input.png secret.pdf output.png

java -jar alterecho.jar -ef output.png extracted.pdf 1024