function EQ = eqnsol(varargin)
%EQNSOL Compute dates of equinoxes and solstices for a given year.
%
%   Syntax
%   ------
%   eqnsol
%   eqnsol(YEAR)
%   eqnsol(YEAR, VERBOSE)
%   eqnsol(YEAR, VERBOSE, 'ReturnType', TYPE)
%   EQ = eqnsol(...)
%
%   Description
%   -----------
%   EQNSOL computes the dates and times of the four main seasonal events
%   for a given year:
%       - Spring (Vernal) Equinox
%       - Summer Solstice
%       - Autumn (Autumnal) Equinox
%       - Winter Solstice
%
%   The computation is based on the polynomial expressions and periodic
%   perturbation terms given by Jean Meeus in:
%
%     Meeus J. (1991). "Astronomical Algorithms".
%
%   The events are first obtained as Julian Dates in Dynamical Time and
%   then converted to civil dates using MATLAB's DATETIME with
%   'ConvertFrom' = 'juliandate'. The returned dates are expressed in
%   UTC/GMT, ignoring Daylight Saving Time.
%
%   Inputs
%   ------
%   Positional inputs:
%     YEAR    : (optional) Scalar numeric, positive integer.
%               The calendar year for which equinoxes and solstices are
%               computed. Default: current year (based on datetime('now')).
%
%     VERBOSE : (optional) Logical or 0/1 flag controlling textual output.
%               1 or true  - print human-readable dates to the Command Window.
%               0 or false - perform computations silently.
%               Default: 1 (true).
%
%   Name-Value options:
%     'ReturnType' : String specifying the type of the returned dates when
%                    an output argument is requested.
%                    Allowed values:
%                      'datenum'  - return MATLAB serial date numbers
%                                   (backward compatible, default).
%                      'datetime' - return a 4-by-1 DATETIME array in UTC.
%                    Default: 'datenum'.
%
%   Traditional call (backward compatible):
%       eqnsol(YEAR, VERBOSE)
%
%   Outputs
%   -------
%   EQ : Dates of equinoxes and solstices, if requested.
%
%        When 'ReturnType' is 'datenum' (default):
%          EQ is a 4-by-1 numeric array (datenum format), where:
%            EQ(1) - Spring Equinox
%            EQ(2) - Summer Solstice
%            EQ(3) - Autumn Equinox
%            EQ(4) - Winter Solstice
%
%        When 'ReturnType' is 'datetime':
%          EQ is a 4-by-1 DATETIME array with TimeZone = 'UTC'.
%
%        If no output is requested, the function only prints the dates
%        (depending on VERBOSE).
%
%   Example
%   -------
%   % Compute equinoxes and solstices for 2007 and print them:
%   eqnsol(2007)
%
%   % Example output:
%   %
%   %   All dates and times are referred to GMT (UTC) without DST
%   %   Spring Equinox    21-Mar-2007 00:08:28
%   %   Summer Solstice   21-Jun-2007 18:07:12
%   %   Autumn Equinox    23-Sep-2007 09:52:05
%   %   Winter Solstice   22-Dec-2007 06:08:51
%   %
%   % Obtain the dates as MATLAB datenums (default):
%   EQnum = eqnsol(2007, 0);
%   %
%   % Obtain the dates as DATETIME objects in UTC:
%   EQdt  = eqnsol(2007, 0, 'ReturnType', 'datetime');
%
%   Notes
%   -----
%   - The underlying formulae from Meeus are valid approximately between
%     years 1000 and 3000 AD. Outside this range, results may become less
%     accurate.
%   - The returned times are expressed in UTC (GMT) when interpreted via
%     DATETIME. No Daylight Saving Time is applied.
%   - Numerical differences of a few seconds compared to high-precision
%     ephemerides are normal, as this routine follows Meeus' simplified
%     analytical expressions.
%
%   Citation
%   --------
%   If you use this function in academic or technical work, please cite:
%
%     Cardillo G. (2007)
%     "Equinoxes and Solstices: compute the date and time of
%      equinoxes and solstices".
%     Available from GitHub:
%     https://github.com/dnafinder/eqnsol
%
%   Metadata
%   --------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2007-01-01
%   Updated: 2025-11-20
%   Version: 2.1.0
%
%   License
%   -------
%   This function is distributed under the MIT License.
%   See the LICENSE file in the GitHub repository for details.
%

% -------------------------------------------------------------------------
% Input parsing and validation
% -------------------------------------------------------------------------
p = inputParser;

% Default year based on current time (MLINT-friendly)
defaultYear = year(datetime('now'));

% YEAR: scalar, positive integer
addOptional(p,'Y',defaultYear, @(x) validateattributes(x,{'numeric'}, ...
    {'scalar','real','finite','integer','nonnan','positive'}, ...
    mfilename,'YEAR',1));

% VERBOSE: 0/1 or logical
addOptional(p,'verbose',1, @(x) isscalar(x) && (x==0 || x==1 || islogical(x)));

% Return type: 'datenum' or 'datetime'
validRT = @(s) any(strcmpi(s,{'datenum','datetime'}));
addParameter(p,'ReturnType','datenum', @(s) validRT(s));

parse(p,varargin{:});
Y        = p.Results.Y;
verbose  = logical(p.Results.verbose);
retType  = lower(p.Results.ReturnType);

% -------------------------------------------------------------------------
% Meeus formula for the mean Julian dates of equinoxes and solstices
% -------------------------------------------------------------------------
% JDME contains the unperturbed (mean) Julian Dates of:
%   [Spring Equinox; Summer Solstice; Autumn Equinox; Winter Solstice]
% expressed in Dynamical Time (Terrestrial Time).

if Y >= 1000
    % Years from 1000 to about 3000 AD
    M = (Y - 2000) / 1000; % millennia from year 2000
    JDME = [ ...
        polyval([-0.00057 -0.00411  0.05169 365242.37404 2451623.80984], M); ...
        polyval([-0.00030  0.00888  0.00325 365241.62603 2451716.56767], M); ...
        polyval([ 0.00078  0.00337 -0.11575 365242.01767 2451810.21715], M); ...
        polyval([ 0.00032 -0.00823 -0.06223 365242.74049 2451900.05952], M) ...
        ];
else
    % Years before 1000 AD (Meeus provides separate polynomials)
    M = Y / 1000;
    JDME = [ ...
        polyval([-0.00071  0.00111  0.06134 365242.13740 1721139.29189], M); ...
        polyval([ 0.00025  0.00907 -0.05323 365241.72562 1721233.25401], M); ...
        polyval([ 0.00074 -0.00297 -0.11677 365242.49558 1721325.70455], M); ...
        polyval([-0.00006 -0.00933 -0.00769 365242.88257 1721414.39987], M) ...
        ];
end

% Julian centuries from J2000.0 (TT)
T = (JDME - 2451545.0) ./ 36525.0;  % 4x1

% -------------------------------------------------------------------------
% Periodic perturbation terms (Meeus)
% -------------------------------------------------------------------------
A = [485; 203; 199; 182; 156; 136;  77;  74;  70;  58;  52;  50; ...
      45;  44;  29;  18;  17;  16;  14;  12;  12;  12;   9;   8];

B = [324.96; 337.23; 342.08;  27.85;  73.14; 171.52; 222.54; 296.72; ...
     243.58; 119.81; 297.17;  21.02; 247.54; 325.15;  60.93; 155.12; ...
     288.79; 198.04; 199.76;  95.39; 287.11; 320.81; 227.73;  15.45];

C = [1934.136; 32964.467;   20.186; 445267.112;  45036.886; 22518.443; ...
      65928.934;  3034.906;  9037.513;  33718.147;   150.678;  2281.226; ...
      29929.562;  31555.956;  4443.417;  67555.328;  4562.452; 62894.029; ...
      31436.921;  14577.848;  31931.756; 34777.259;  1222.114; 16859.074];

% Compute the sum of periodic terms S (Meeus, in arcseconds).
% Use BSXFUN to avoid explicit REPMAT/KRON and keep backward compatibility.
theta = bsxfun(@plus, B, bsxfun(@times, C, T.'));   % 24-by-4
S     = (A.' * cosd(theta)).';                      % 4-by-1

% -------------------------------------------------------------------------
% Final correction from mean JD to apparent JD
% -------------------------------------------------------------------------
W = 35999.373 .* T - 2.47;                       % degrees
L = 1 + 0.0334 .* cosd(W) + 0.00007 .* cosd(2.*W);

% Final Julian Dates in Dynamical Time (Meeus' formula)
JD = JDME + 0.00001 .* (S ./ L);

% -------------------------------------------------------------------------
% Convert Julian Date to MATLAB date/time (UTC/GMT, no DST)
% -------------------------------------------------------------------------
% Use MATLAB's DATETIME to convert from astronomical Julian Date to a
% calendar date, explicitly in UTC.
dt = datetime(JD, 'ConvertFrom', 'juliandate', 'TimeZone', 'UTC');

% -------------------------------------------------------------------------
% Optional verbose output (using DATETIME, not DATESTR)
% -------------------------------------------------------------------------
if verbose
    event = { ...
        'Spring Equinox    '; ...
        'Summer Solstice   '; ...
        'Autumn Equinox    '; ...
        'Winter Solstice   '};

    disp('All dates and times are referred to GMT (UTC) without DST')

    for k = 1:4
        % Format the datetime explicitly in a date-time style similar to datestr(,0)
        tstr = char(dt(k), 'dd-MMM-yyyy HH:mm:ss');
        disp([event{k}, tstr])
    end
end

% -------------------------------------------------------------------------
% Optional function output (ReturnType: 'datenum' or 'datetime')
% -------------------------------------------------------------------------
if nargout > 0
    switch retType
        case 'datetime'
            EQ = dt;
        otherwise
            % Backward compatible: return MATLAB serial date numbers
            EQ = datenum(dt); %#ok<DATNM>
    end
end

end
