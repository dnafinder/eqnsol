[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/eqnsol)

📌 Overview
This repository provides the MATLAB function eqnsol, which computes the dates and times of the four main seasonal events for a given year: the spring (vernal) equinox, the summer solstice, the autumn (autumnal) equinox, and the winter solstice. The implementation follows the analytical formulas of Jean Meeus and returns the results either as MATLAB serial date numbers (for backward compatibility) or as datetime objects.

✨ Features
The function eqnsol implements Meeus-style polynomial expressions and periodic perturbation terms to estimate the instants of equinoxes and solstices over a wide range of years (roughly 1000–3000 AD). It computes the events in Julian Date and then converts them to civil calendar dates using MATLAB's datetime capabilities. The results are expressed in UTC/GMT without Daylight Saving Time. Users can control the verbosity of textual output and can choose the return type between datenum and datetime.

🛠 Installation
Download or clone this repository from GitHub:
https://github.com/dnafinder/eqnsol

Add the folder containing eqnsol.m to your MATLAB path using the Add Folder to Path option or the addpath command. The function relies only on core MATLAB functionality, including datetime and basic trigonometric functions, so no additional toolboxes are required.

▶️ Usage
The simplest usage is to call eqnsol with a year. When called without an output argument, the function prints the four events in the Command Window. When called with an output argument, the function returns either a vector of MATLAB datenums or a vector of datetime objects in UTC, depending on the ReturnType option.

Examples:
eqnsol                 % use the current year, verbose output, no return
eqnsol(2007)           % equinoxes and solstices for 2007, printed to Command Window
eqnsol(2025, 0)        % compute for 2025, but do not print
EQnum = eqnsol(2007);  % return a 4-by-1 datenum vector (default ReturnType)
EQdt  = eqnsol(2007, 0, 'ReturnType', 'datetime');  % return a 4-by-1 datetime vector

🎛 Inputs
The function accepts up to two positional inputs and a Name-Value pair:

YEAR    : Scalar numeric, positive integer. The calendar year for which equinoxes and solstices are computed. If omitted, the current year (based on datetime('now')) is used.

VERBOSE : Logical or 0/1 flag controlling textual output. When 1 or true, the function prints the four events and their UTC times in the Command Window. When 0 or false, the computation is silent and only the optional output is produced. If omitted, the default is 1 (verbose).

ReturnType (Name-Value):
'ReturnType' : String specifying how the dates should be returned when an output argument is requested.
               'datenum'  - return a 4-by-1 numeric vector of MATLAB serial date numbers (backward compatible, default).
               'datetime' - return a 4-by-1 datetime vector with TimeZone set to 'UTC'.

The traditional call used in older code remains:
eqnsol(YEAR, VERBOSE)

📤 Outputs
By default, if no output is requested, eqnsol only prints a formatted list of the four seasonal events, including date and time in UTC. If an output is requested:

EQ = eqnsol(...)

the function returns either:
- a 4-by-1 numeric array of MATLAB serial date numbers (datenum), if ReturnType is 'datenum'; or
- a 4-by-1 datetime array with TimeZone = 'UTC', if ReturnType is 'datetime'.

The order of events is always:
EQ(1) : Spring Equinox
EQ(2) : Summer Solstice
EQ(3) : Autumn Equinox
EQ(4) : Winter Solstice

🔍 Interpretation
The algorithm in eqnsol is based on the polynomial approximations and periodic perturbation series from Jean Meeus' "Astronomical Algorithms". The resulting dates are suitable for many educational, illustrative, and medium-precision applications. Small differences on the order of seconds compared to high-precision numerical ephemerides are expected. The reference time scale used for the output is UTC, obtained by converting astronomical Julian Dates using MATLAB's datetime with 'ConvertFrom' set to 'juliandate' and specifying the 'UTC' time zone.

📝 Notes
The underlying formulae are most accurate between years 1000 and 3000 AD. For years far outside this range, the approximations may degrade. All displayed and returned times are in UTC (often described as GMT) and do not include any Daylight Saving Time adjustments. The ReturnType option allows a smooth transition from older workflows based on datenum to modern datetime-based code without breaking existing scripts.

📚 Citation
If you use this code in scientific, educational, or technical work, please cite it as:

Cardillo G. (2007)
"Equinoxes and Solstices: compute the date and time of equinoxes and solstices".
Available from GitHub:
https://github.com/dnafinder/eqnsol

👤 Author
Author: Giuseppe Cardillo
Email: giuseppe.cardillo.75@gmail.com
GitHub: https://github.com/dnafinder

⚖️ License
This project is distributed under the MIT License. You are free to use, modify, and redistribute the code, provided that the original copyright notice and license text are preserved. The full license terms are provided in the LICENSE file in this GitHub repository.
