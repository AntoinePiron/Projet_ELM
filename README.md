# Projet ELP
*Groupe projet : Salma Aziz-Alaoui / Tristan Devin / Yasser Issam / Antoine Piron*

## Run the project
First of all you can download the project with `git clone https://github.com/AntoinePiron/Projet_ELM.git` <br />
In order to run the project you can just open the [index.html](./index.html) file. <br/>

If you need to recompile the project you can use the provided script by typing the `./compile`command but you need to have Elm and UglifyJS installed on your computer. <br />
 - Install Elm [here](https://guide.elm-lang.org/install/elm.html)
 - Install UglifyJS with npm : `npm install uglify-js -g`

## Structure of the Elm code
We have 4 Elm files working together : 
 - *__MyTypes.elm__* &rarr; the custom types that we'll need in all the files.
 - *__MyParser.elm__* &rarr; the parser used to check if the user input is an instruction runnable by TcTurtle.
 - *__DrawingZone.elm__* &rarr; all the functiun needed to generate the svg structure from the instructions.
 - *__Main.elm__* &rarr; the main program who defines the page with the model, view and update functions.

## Particular package 
We used elm natives packages : 
 - browser
 - core
 - html
 - parser
 - svg <br/>

But we also installed the package [carwow/elm-slider](https://github.com/carwow/elm-slider) in order to generate the slider for the line thickness.