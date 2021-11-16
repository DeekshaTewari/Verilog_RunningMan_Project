# Verilog_RunningMan_Project
Project developed using Verilog for the FPGA. It is a game where the avatar needs to avoid obstacles

# Description of Modules: 

All of these modules are present in running_game.v:

**runningman:** This is the top level module that has wires connecting all the lower modules, allowing for real time updates to all modules.
**vga_adapter:**  This is the module that connected to the DAC and updated the screen every 1/60s. The x and y inputs were modified through inputs from the datapath, and the colour to be plotted would be described by if the player, object or background (erase state) was being plotted
**Audio_module:** This module contains the inputs and outputs to produce an ominous dinging sound as soon as the game starts. 
**Y_counter**: This is the counter that holds the y position of the object. Depending on it’s property (if it’s a hole, a long object, a short object), the y position is offset accordingly
**X_counter**: This increments the object position, and if the dash key is pressed, it increments the object position by two pixels (dashing). It also records when the obstacle reaches the other side of the screen (x = 0), enable the randomiser to output a value for what the next object should be.
**PlayerReg**: This waits for the jump key to be pressed in which case the player is made to rise by 16 pixels, and when they key is unpressed, the original position of the player is restored.
**RateDivideCounter**: This creates the gameClock at 60Hz, so that the objects and players can be plotted correctly. 
**FrameCounter**: This waits for 15 impulses from the gameClock, and then produces an enable signal that is used as a hold state. This hold state ensures that the player and the object have been on the screen for sufficient amounts of time.
**ScoreKeeper**: This module keeps track of the score and if collision has been detected. It takes inputs from the player and object registers, comparing x and y values. If a collision is detected, a signal is sent to the control path. Otherwise it keeps track of the score and increments it. 
random: Produces a random number between 0 and 2, where 0 described a hole type object, 1 described an object with the same size as the player, and 2 is the long object. This uses the LSFR to produce these randomised values. 
**gameLevel**: Depending on the switch choices, it increases the speed of the gameClock, which increases the speed at which the obstacles move.
drawBackground: 
**Control**: This is the module that enacts the control logic Finite State Machine. There were 8 states: Start, S_LOAD (loads VGA with register values), S_PLOT_P, (plots the player) S_HOLD_P, S_PLOT_O (plots the object), S_HOLD_O (waits for 15 frames to pass), S_collide (checks for collision), S_Erase(redraws background). This module provides the signals that drive the computation in the datapath and the rest of the modules.
