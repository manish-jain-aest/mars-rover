# mars-rover

Sample code fro problem statement as below:

Mars Rover Challenge: 

A squad of robotic rovers are to be landed by NASA on a plateau on Mars. This plateau, which is curiously rectangular, must be navigated by the rovers so that their on-board cameras can get a complete view of the surrounding terrain to send back to Earth. A rover's position and location is represented by a combination of x and y co-ordinates and a letter representing one of the four cardinal compass points. The plateau is divided up into a grid to simplify navigation. An example position might be 0, 0, N, which means the rover is in the bottom left corner and facing North. In order to control a rover, NASA sends a simple string of letters. The possible letters are 'L', 'R' and 'M'. 'L' and 'R' makes the rover spin 90 degrees left or right respectively, without moving from its current spot. 'M' means move forward one grid point, and maintain the same heading.
Assume that the square directly North from (x, y) is (x, y+1).

INPUT:
The first line of input is the upper-right coordinates of the plateau, the lower-left coordinates are assumed to be 0,0.
The rest of the input is information pertaining to the rovers that have been deployed. Each rover has two lines of input. The first line gives the rover's position, and the second line is a series of instructions telling the rover how to explore the plateau. The position is made up of two integers and a letter separated by spaces, corresponding to the x and y co-ordinates and the rover's orientation.
Each rover will be finished sequentially, which means that the second rover won't start to move until the first one has finished moving.

OUTPUT:
The output for each rover should be its final co-ordinates and heading.

INPUT AND OUTPUT:

Test Input:
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM

Expected Output:
1 3 N
5 1 E

Additional instructions
	•	Please submit the solution that displays all the steps you have undertaken.
	•	Please include the version of Xcode and Swift that you are using to write the code
	•	Please ensure we can build and run the application and that there are no compile errors
	•	The solution should be written in swift and be able to be run in the simulator (e.g, any user input required can use just a simple textbox. Any output should be displayed on a label or text element of your choice.
	•	Add a GUI that displays the Rovers and updates as it processes the commands
	•	Please ensure that your application correctly accepts the test input, and also correctly outputs the expected result (provided above).
	•	If you have any other specific instructions to run the app please include them in the solution also.
	•	If anything is unclear please don't hesitate to reach out to us for clarification.
	•	We'll be looking at a number of things when assessing the solution, and we'll have the opportunity to go through it together afterwards to explain your thinking about why you made certain decisions in the code and why you approached things in a certain way.
