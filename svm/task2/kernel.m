function rs=Kernal(x, z,d)
%{
This function is for calculating kernal function 
x and z is the vector to be map into higher dimension
rs is the return value 
%}

rs = ((x * z') + 1)^d;

