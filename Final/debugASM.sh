#---------------------
# DEBUG Script
#--------------------

# By Benjamin Boden & Derek Park
# 08/12/12022
# runs our Final project, and shows the veriable values to the 
# console

# to use:
# Start GDB debugger into your executible ASM file
# in GDB pass it the comand "source <thisFile.sh>"



# START PROGRAM
echo \n\n			
b square				
run				

# START LOGGING:
set pagination off
set logging file example.out
set logging overwrite
set logging on
set prompt

# DESPLAY TEXT:
echo ---------------------------------------\n
echo display variables\n
echo \n

# DESPLAY VARIABLES:
x/s     &inLine
x/s     &outLine
x/dw    &newInt


# END DEBUG:
echo Continue debuging:\n
echo \n\n

	

