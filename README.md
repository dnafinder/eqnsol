# eqnsol
Equinoxes and Solstices<br/>
EQNSOL computes the date of equinoxes and solstices for the input year.
This is based upon the formulas given by Jean Meeus in his "Astronomical
Algorithms". The date is computed in Julian Date. 
This function take in JD2CAL function of "Geodetic Toolbox" by Mike
Craymer (ID:15285) to convert Julian Date into gregorian calendar date.

Syntax: 	Y=EQNSOL(YEAR,VERBOSE)
     
    Inputs:
          YEAR (default=current Year). 
          VERBOSE (default=1)
    Outputs:
          - Y=datenum formatted array.

EQ=EQNSOL(...) will stores dates in Matlab format

     Example: 

     y=eqnsol(2007)

        All dates and times are referred to GMT without DST
        Spring Equinox    21-Mar-2007 00:08:28
        Summer Solstice   21-Jun-2007 18:07:12
        Autumn Equinox    23-Sep-2007 09:52:05
        Winter Solstice   22-Dec-2007 06:08:51


          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2007) Equinoxes and Solstices: compute the date and time of
equinoxes and solstices. 
http://www.mathworks.com/matlabcentral/fileexchange/17977
